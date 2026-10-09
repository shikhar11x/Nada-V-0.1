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