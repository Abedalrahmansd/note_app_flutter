import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:notes_app/app/core/exceptions/api_exception.dart';
import 'package:notes_app/app/data/models/note_model.dart';
import 'package:notes_app/app/utils/helping_functions.dart';

void main() {
  group('normalizeHexColor', () {
    test('adds exactly one #, upper-cases', () {
      expect(normalizeHexColor('ffe066'), '#FFE066');
      expect(normalizeHexColor('#ffe066'), '#FFE066');
    });
    test('never produces ## (re-saving a note that already has a #)', () {
      expect(normalizeHexColor('##FFE066'), '#FFE066');
    });
    test('drops an AARRGGBB alpha prefix', () {
      expect(normalizeHexColor('FF1D1D28'), '#1D1D28');
    });
    test('falls back on garbage', () {
      expect(normalizeHexColor(null), '#FFFFFF');
      expect(normalizeHexColor(''), '#FFFFFF');
      expect(normalizeHexColor('red'), '#FFFFFF');
      expect(normalizeHexColor('zzzzzz', fallback: '#000000'), '#000000');
    });
    test('hexWithoutHash matches the colour-picker form', () {
      expect(hexWithoutHash('#B5EAD7'), 'B5EAD7');
      expect(hexWithoutHash(null), 'FFFFFF');
    });
  });

  group('NoteModel.fromJson', () {
    test('reads a typical Laravel/MySQL row (0/1 booleans, tag string)', () {
      final n = NoteModel.fromJson({
        'id': 7,
        'title': 'T',
        'content': 'C',
        'color': '#A9DEF9',
        'is_pinned': 1,
        'is_archived': 0,
        'is_deleted': 0,
        'tags': 'work, study ,',
        'created_at': '2026-01-01T10:00:00.000000Z',
      });
      expect(n.id, 7);
      expect(n.isPinned, true);
      expect(n.isArchived, false);
      expect(n.tags, ['work', 'study']);
      expect(n.createdAt, DateTime.utc(2026, 1, 1, 10));
    });

    test('accepts real booleans, string ids, list tags and missing fields', () {
      final n = NoteModel.fromJson({
        'id': '12',
        'title': null,
        'is_pinned': true,
        'is_archived': 'true',
        'tags': ['x', 'y'],
      });
      expect(n.id, 12);
      expect(n.title, '');
      expect(n.isPinned, true);
      expect(n.isArchived, true);
      expect(n.tags, ['x', 'y']);
      expect(n.createdAt, isNull);
      expect(NoteModel.fromJson({'id': 1, 'title': 'a'}).tags, isEmpty);
    });

    test('round-trips through toJson', () {
      final n = NoteModel.fromJson({'id': 1, 'title': 'a', 'tags': 'p,q', 'is_pinned': 1});
      final again = NoteModel.fromJson(n.toJson());
      expect(again.tags, ['p', 'q']);
      expect(again.isPinned, true);
    });
  });

  group('apiErrorMessage', () {
    Response<dynamic> res(int? status, dynamic body) =>
        Response(statusCode: status, body: body);

    test('prefers the first validation error', () {
      final m = apiErrorMessage(res(422, {
        'message': 'The given data was invalid.',
        'errors': {
          'email': ['The email has already been taken.'],
        },
      }));
      expect(m, 'The email has already been taken.');
    });
    test('uses the server message when there are no field errors', () {
      expect(apiErrorMessage(res(401, {'message': 'Unauthenticated.'})), 'Unauthenticated.');
    });
    test('no status code means the server was not reached', () {
      expect(apiErrorMessage(res(null, null)), 'Api->No_Connection');
    });
    test('falls back to a generic message', () {
      expect(apiErrorMessage(res(500, '<html>oops</html>')), 'Api->Error_Generic');
    });
  });
}
