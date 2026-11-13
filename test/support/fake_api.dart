import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// A tiny in-memory imitation of the notes REST API (Laravel-style JSON), used
/// to test the app's networking without the real server.
///
/// Mimics MySQL/Laravel habits on purpose: booleans as 0/1, tags as a comma
/// string, ids as numbers, `{ "data": ... }` wrapping, 401 without a token and
/// 422 validation errors.
class FakeApi {
  FakeApi._(this._server);

  static const validToken = 'tok-123';
  static const password = 'secret-pass';

  final HttpServer _server;
  final List<Map<String, dynamic>> notes = [];
  int _nextId = 1;

  /// Every request body the server received for `POST/PUT` calls, newest last.
  final List<({String method, String path, Map<String, dynamic> body})> log = [];

  /// Authorization headers seen on /logout.
  final List<String?> logoutAuthHeaders = [];

  String get baseUrl => 'http://127.0.0.1:${_server.port}';

  static Future<FakeApi> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final api = FakeApi._(server);
    server.listen(api._handle);
    return api;
  }

  Future<void> stop() => _server.close(force: true);

  /// Adds a note directly (as if created earlier on another device).
  Map<String, dynamic> seed(String title, {String color = '#FFFFFF'}) {
    final now = DateTime.utc(2026, 1, 1).add(Duration(minutes: _nextId));
    final note = {
      'id': _nextId++,
      'title': title,
      'content': 'body of $title',
      'color': color,
      'is_pinned': 0,
      'is_archived': 0,
      'is_deleted': 0,
      'category': null,
      'tags': 'a, b',
      'status': 'draft',
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };
    notes.add(note);
    return note;
  }

  Future<void> _handle(HttpRequest req) async {
    final raw = await utf8.decoder.bind(req).join();
    final body = raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
    final path = req.uri.path;
    if (req.method != 'GET') {
      log.add((method: req.method, path: path, body: body));
    }

    void send(int status, Object? json) {
      req.response.statusCode = status;
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode(json));
      req.response.close();
    }

    // ---- auth (no token needed)
    if (path == '/login') {
      if (body['password'] == password) {
        return send(200, {'access_token': validToken, 'token_type': 'Bearer'});
      }
      return send(401, {'message': 'These credentials do not match our records.'});
    }
    if (path == '/register') {
      if (body['email'] == 'taken@example.com') {
        return send(422, {
          'message': 'The email has already been taken.',
          'errors': {
            'email': ['The email has already been taken.'],
          },
        });
      }
      return send(201, {'message': 'registered'});
    }

    // ---- everything below needs the bearer token
    final auth = req.headers.value('authorization');
    if (path == '/logout') {
      logoutAuthHeaders.add(auth);
      return send(200, {'message': 'logged out'});
    }
    if (auth != 'Bearer $validToken') {
      return send(401, {'message': 'Unauthenticated.'});
    }

    if (path == '/notes' && req.method == 'GET') {
      return send(200, {'data': notes});
    }
    if (path == '/notes' && req.method == 'POST') {
      final note = seed(body['title']?.toString() ?? '');
      _merge(note, body);
      return send(201, {'data': note});
    }

    final match = RegExp(r'^/notes/(\d+)(?:/([a-z-]+))?$').firstMatch(path);
    if (match != null) {
      final id = int.parse(match.group(1)!);
      final action = match.group(2);
      final index = notes.indexWhere((n) => n['id'] == id);
      if (index == -1) return send(404, {'message': 'Not found.'});
      final note = notes[index];

      if (req.method == 'DELETE') {
        notes.removeAt(index);
        return send(200, {'message': 'deleted'});
      }
      switch (action) {
        case null:
          _merge(note, body);
        case 'pin':
          note['is_pinned'] = 1;
        case 'unpin':
          note['is_pinned'] = 0;
        case 'archive':
          note['is_archived'] = 1;
        case 'unarchive':
          note['is_archived'] = 0;
        case 'mark-deleted':
          note['is_deleted'] = 1;
        case 'color':
          note['color'] = body['color'];
        case 'status':
          note['status'] = body['status'];
        default:
          return send(404, {'message': 'Not found.'});
      }
      return send(200, {'data': note});
    }
    send(404, {'message': 'Not found.'});
  }

  void _merge(Map<String, dynamic> note, Map<String, dynamic> body) {
    for (final key in ['title', 'content', 'color', 'status']) {
      if (body[key] != null) note[key] = body[key];
    }
    if (body['is_pinned'] != null) note['is_pinned'] = body['is_pinned'] == true ? 1 : 0;
  }
}

/// In-memory stand-in for flutter_secure_storage's platform channel.
final Map<String, String> fakeSecureStorage = {};

void mockSecureStorage() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (call) async {
      final args = (call.arguments as Map?) ?? {};
      final key = args['key'] as String?;
      switch (call.method) {
        case 'read':
          return fakeSecureStorage[key];
        case 'write':
          fakeSecureStorage[key!] = args['value'] as String;
          return null;
        case 'delete':
          fakeSecureStorage.remove(key);
          return null;
        case 'deleteAll':
          fakeSecureStorage.clear();
          return null;
        case 'readAll':
          return Map<String, String>.from(fakeSecureStorage);
        case 'containsKey':
          return fakeSecureStorage.containsKey(key);
      }
      return null;
    },
  );
}
