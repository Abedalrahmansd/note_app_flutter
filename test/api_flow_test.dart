import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:notes_app/app/core/exceptions/api_exception.dart';
import 'package:notes_app/app/core/network/api_service.dart';
import 'package:notes_app/app/data/providers/auth_provider.dart';
import 'package:notes_app/app/data/providers/note_provider.dart';
import 'package:notes_app/app/modules/notes/controllers/implementations/i_note_controller.dart';
import 'package:notes_app/app/modules/notes/controllers/note_controller.dart';

import 'support/fake_api.dart';

/// Online-mode tests against an in-process fake of the notes REST API.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeApi server;
  late ApiService api;
  var unauthorizedCalls = 0;

  setUpAll(() {
    HttpOverrides.global = null; // flutter_test blocks real sockets by default
    mockSecureStorage();
  });

  setUp(() async {
    Get.reset();
    fakeSecureStorage.clear();
    unauthorizedCalls = 0;
    server = await FakeApi.start();
    api = ApiService(baseUrl: server.baseUrl)
      ..onUnauthorized = () => unauthorizedCalls++;
    Get.put(api, permanent: true);
  });

  tearDown(() async {
    await server.stop();
  });

  Future<void> logIn() => AuthProvider(baseUrl: server.baseUrl).saveToken(FakeApi.validToken);

  group('authentication', () {
    test('login returns the access token', () async {
      final res = await AuthProvider(baseUrl: server.baseUrl)
          .login('me@example.com', FakeApi.password);
      expect(res.isOk, isTrue);
      expect(res.body['access_token'], FakeApi.validToken);
    });

    test('wrong password: not ok, readable server message', () async {
      final res = await AuthProvider(baseUrl: server.baseUrl)
          .login('me@example.com', 'wrong');
      expect(res.isOk, isFalse);
      expect(apiErrorMessage(res), 'These credentials do not match our records.');
    });

    test('register shows the first validation error', () async {
      final res = await AuthProvider(baseUrl: server.baseUrl)
          .register('Me', 'taken@example.com', 'pw123456', 'pw123456');
      expect(res.isOk, isFalse);
      expect(apiErrorMessage(res), 'The email has already been taken.');
      // The client sends password_confirmation, as Laravel expects.
      expect(server.log.last.body['password_confirmation'], 'pw123456');
    });

    test('notes need a token; 401 with a stale token fires onUnauthorized', () async {
      fakeSecureStorage['auth_token'] = 'expired-token';
      final res = await NoteProvider().getNotes();
      expect(res.statusCode, 401);
      expect(unauthorizedCalls, 1);
    });

    test('no token at all: 401 but no "session expired" redirect', () async {
      final res = await NoteProvider().getNotes();
      expect(res.statusCode, 401);
      expect(unauthorizedCalls, 0);
    });

    test('logout reaches the server with the token still attached', () async {
      await logIn();
      await AuthProvider(baseUrl: server.baseUrl).logout();
      expect(server.logoutAuthHeaders.single, 'Bearer ${FakeApi.validToken}');
    });
  });

  group('NoteController (online)', () {
    late NoteController c;

    setUp(() async {
      await logIn();
      server.seed('First', color: '#A9DEF9');
      server.seed('Second');
      c = NoteController();
      await c.fetchNotes();
    });

    test('loads notes and parses MySQL-style 0/1 flags and tag strings', () {
      expect(c.allNotes.length, 2);
      expect(c.notes.length, 2);
      expect(c.allNotes.first.isPinned, false);
      expect(c.allNotes.first.tags, ['a', 'b']);
    });

    test('a newly created note can be pinned straight away (was dropped before)', () async {
      await c.createNote('Fresh', 'hello', 'FFE066', false);
      expect(c.allNotes.length, 3);
      expect(c.notes.length, 3);
      final fresh = c.allNotes.firstWhere((n) => n.title == 'Fresh');

      await c.pinNote(fresh.id);

      expect(c.notes.length, 3, reason: 'pinning must not make a note vanish');
      expect(c.notes.first.title, 'Fresh', reason: 'pinned notes sort first');
      expect(c.notes.first.isPinned, true);
    });

    test('a deleted note does not come back after the next pin/archive', () async {
      final doomed = c.allNotes.first.id;
      final other = c.allNotes.last.id;

      await c.deleteNote(doomed);
      await c.pinNote(other);

      expect(c.notes.any((n) => n.id == doomed), isFalse);
      expect(c.allNotes.any((n) => n.id == doomed), isFalse);
      expect(server.notes.any((n) => n['id'] == doomed), isFalse);
    });

    test('colour sent to the server is #RRGGBB, never ##RRGGBB', () async {
      final note = c.allNotes.first; // stored as '#A9DEF9'
      await c.updateNote(note.id, 'First (edited)', 'x', note.color, false);
      expect(server.log.last.body['color'], '#A9DEF9');

      await c.createNote('Colourful', 'x', 'B5EAD7', false); // picker form, no '#'
      expect(server.log.last.body['color'], '#B5EAD7');
    });

    test('update replaces the note in both lists', () async {
      final id = c.allNotes.first.id;
      await c.updateNote(id, 'Renamed', 'new body', '#FFFFFF', true);
      expect(c.allNotes.firstWhere((n) => n.id == id).title, 'Renamed');
      expect(c.notes.firstWhere((n) => n.id == id).title, 'Renamed');
      expect(c.notes.first.id, id, reason: 'pinned now, so on top');
    });

    test('archive hides a note; archived view shows only archived notes', () async {
      final id = c.allNotes.first.id;
      await c.archiveNote(id);
      expect(c.allNotes.firstWhere((n) => n.id == id).isArchived, true);

      c.filterOnlyArchived();
      expect(c.notes.map((n) => n.id), [id]);

      // Pinning inside the archived view must keep the filter.
      await c.pinNote(id);
      expect(c.notes.map((n) => n.id), [id]);

      await c.unarchiveNote(id);
      expect(c.notes, isEmpty, reason: 'archived view is now empty');
      c.unfilterAll();
      expect(c.notes.length, 2);
    });

    test('sorting keeps pinned notes first', () async {
      await c.pinNote(c.allNotes.last.id);
      c.sortNotes(SortType.titleAsc);
      expect(c.notes.first.isPinned, true);
    });

    test('empty title and body are not sent', () async {
      await c.createNote('', '', 'FFFFFF', false);
      expect(server.log.where((e) => e.path == '/notes' && e.method == 'POST'), isEmpty);
    });
  });

  group('no connection', () {
    test('requests fail quietly with a "no connection" message', () async {
      await logIn();
      await server.stop();
      final c = NoteController();
      await c.fetchNotes(); // must not throw
      expect(c.allNotes, isEmpty);

      final res = await NoteProvider().getNotes();
      expect(res.statusCode, isNull);
      expect(apiErrorMessage(res), 'Api->No_Connection');
    });
  });
}
