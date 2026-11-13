# Notes

A bilingual (Arabic / English) notes app built with Flutter and GetX.

- **Offline mode:** notes are stored on the device (Hive).
- **Online mode (experimental):** sign in and keep notes on a REST API (Laravel-style JSON).
- Colours, pin, archive, search, sorting, light/dark theme, and WhatsApp-style
  formatting in the note body (`*bold*`, `_italic_`, `~strike~`, `#underline#`, `` `code` ``).

Android package id: `dev.abedalrahman.notes`.

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
```

The online-mode tests run against an in-process fake of the API
(`test/support/fake_api.dart`), so no server is needed.

## API

The base URL is `webBaseUrl` in `lib/app/core/constants/app_constants.dart`.
The app expects: `POST /login` -> `{ "access_token": "..." }`, `POST /register`,
`POST /logout`, and bearer-protected `GET|POST /notes`, `POST /notes/{id}`,
`DELETE /notes/{id}`, `POST /notes/{id}/{pin|unpin|archive|unarchive}` returning
`{ "data": { ...note... } }`.
