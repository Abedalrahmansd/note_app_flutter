/// Returns a colour as `#RRGGBB` (upper case, exactly one leading `#`).
///
/// Notes come from two places: the colour picker (`FFE066`) and the API / Hive
/// (`#FFE066`). Adding a `#` blindly produced `##FFE066` on re-save.
/// Returns [fallback] for null, empty or malformed input.
String normalizeHexColor(String? value, {String fallback = '#FFFFFF'}) {
  var hex = (value ?? '').trim().replaceAll('#', '').toUpperCase();
  if (hex.length == 8) hex = hex.substring(2); // drop AARRGGBB alpha
  if (!RegExp(r'^[0-9A-F]{6}$').hasMatch(hex)) return fallback;
  return '#$hex';
}

/// Same as [normalizeHexColor] but without the leading `#` (colour-picker form).
String hexWithoutHash(String? value, {String fallback = 'FFFFFF'}) =>
    normalizeHexColor(value, fallback: '#$fallback').substring(1);
