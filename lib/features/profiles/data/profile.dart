/// One profile from the dataset. Every field except id and name may be absent.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    this.age,
    this.gender,
    this.city,
    this.community,
    this.profession,
    this.education,
    this.degree,
    this.connectedThrough,
    this.about,
    required this.raw,
  });

  final int id;
  final String name;
  final int? age;
  final String? gender;
  final String? city;
  final String? community;
  final String? profession;
  final String? education;
  final int? degree;
  final String? connectedThrough;
  final String? about;

  /// The untouched source JSON, kept so no field is ever lost.
  final Map<String, dynamic> raw;

  bool get hasConnection => connectedThrough != null;

  /// Case-insensitive match on name and city. Blank query matches everyone.
  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        (city?.toLowerCase().contains(q) ?? false);
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    final id = _asInt(json['id']);
    final name = _asString(json['name']);
    if (id == null || name == null) {
      throw FormatException('Profile needs a valid id and name: $json');
    }
    return Profile(
      id: id,
      name: name,
      age: _asInt(json['age']),
      gender: _asString(json['gender']),
      city: _asString(json['city']),
      community: _asString(json['community']),
      profession: _asString(json['profession']),
      education: _asString(json['education']),
      degree: _asInt(json['degree']),
      connectedThrough: _asString(json['connected_through']),
      about: _asString(json['about']),
      raw: Map<String, dynamic>.unmodifiable(json),
    );
  }
}

/// Null, non-string and blank values all become null.
String? _asString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num && value == value.roundToDouble()) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}