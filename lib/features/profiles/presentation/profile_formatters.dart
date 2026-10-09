import 'package:nada/features/profiles/data/profile.dart';

/// 1 -> 1st, 2 -> 2nd, 3 -> 3rd, 4 -> 4th, 11 -> 11th ...
String ordinal(int n) {
  final lastTwo = n.abs() % 100;
  if (lastTwo >= 11 && lastTwo <= 13) return '${n}th';
  switch (n.abs() % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

/// "Ananya Sharma" -> "AS", "Rajeshwari Nandini Mishra Chaturvedi" -> "RC".
/// Works with Devanagari too because it uses the first rune of each word.
String initialsOf(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return '?';
  String first(String w) => String.fromCharCode(w.runes.first).toUpperCase();
  if (words.length == 1) return first(words.first);
  return first(words.first) + first(words.last);
}

/// Joins the non-null, non-blank parts with a separator. Returns null if none.
String? joinNonEmpty(Iterable<String?> parts, {String separator = ' · '}) {
  final kept = parts.whereType<String>().where((s) => s.trim().isNotEmpty);
  return kept.isEmpty ? null : kept.join(separator);
}

/// "24 profiles" or "3 of 24 profiles" while searching.
String resultsLabel({
  required int shown,
  required int total,
  required String query,
}) {
  final noun = total == 1 ? 'profile' : 'profiles';
  if (query.trim().isEmpty) return '$total $noun';
  return '$shown of $total $noun';
}

/// One spoken sentence for screen readers.
String profileSemanticsLabel(Profile p) {
  final parts = <String>[p.name];
  final age = p.age;
  if (age != null) parts.add('age $age');
  final city = p.city;
  if (city != null) parts.add(city);
  final connection = p.connectedThrough;
  parts.add(
    connection != null ? 'Connected through: $connection' : 'No connection yet',
  );
  return parts.join(', ');
}

typedef ProfileField = ({String label, String value});

const Set<String> _knownKeys = {
  'id',
  'name',
  'age',
  'gender',
  'city',
  'community',
  'profession',
  'education',
  'degree',
  'connected_through',
  'about',
};

/// "F" -> "Female", "M" -> "Male". Anything else is shown as given.
String? genderLabel(String? gender) {
  if (gender == null) return null;
  switch (gender.trim().toUpperCase()) {
    case 'F':
      return 'Female';
    case 'M':
      return 'Male';
    default:
      return gender;
  }
}

/// "marital_status" -> "Marital status".
String humanizeKey(String key) {
  final words = key.split(RegExp(r'[_\s]+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return key;
  final text = words.join(' ');
  return text[0].toUpperCase() + text.substring(1);
}

/// Label/value pairs for the details card. Absent fields are skipped, so the
/// UI never shows placeholder text. `about` and `connected_through` have their
/// own sections and are not listed here.
List<ProfileField> profileFields(Profile p) {
  final fields = <ProfileField>[];

  void add(String label, String? value) {
    if (value == null || value.trim().isEmpty) return;
    fields.add((label: label, value: value));
  }

  add('Age', p.age?.toString());
  add('Gender', genderLabel(p.gender));
  add('City', p.city);
  add('Community', p.community);
  add('Profession', p.profession);
  add('Education', p.education);
  final degree = p.degree;
  add('Degree', degree == null ? null : ordinal(degree));

  // Any field in the source JSON that this app does not know about yet.
  p.raw.forEach((key, value) {
    if (_knownKeys.contains(key)) return;
    if (value is String || value is num || value is bool) {
      add(humanizeKey(key), value.toString());
    }
  });

  add('Profile ID', p.id.toString());
  return fields;
}
