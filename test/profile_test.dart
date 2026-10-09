import 'package:flutter_test/flutter_test.dart';

import 'package:nada/features/profiles/application/profile_providers.dart';
import 'package:nada/features/profiles/data/profile.dart';

Profile _profile(int id, String name, String? city) =>
    Profile.fromJson({'id': id, 'name': name, 'city': city});

void main() {
  group('Profile.fromJson', () {
    test('parses a full profile', () {
      final p = Profile.fromJson({
        'id': 1,
        'name': 'Ananya Sharma',
        'age': 27,
        'city': 'Noida',
        'degree': 1,
        'connected_through': 'Your cousin Nikhil knows her brother.',
      });
      expect(p.name, 'Ananya Sharma');
      expect(p.age, 27);
      expect(p.degree, 1);
      expect(p.hasConnection, isTrue);
    });

    test('treats null, missing and blank values as absent', () {
      final p = Profile.fromJson({
        'id': 10,
        'name': 'Nikhil Yadav',
        'degree': null,
        'connected_through': null,
        'about': '   ',
      });
      expect(p.degree, isNull);
      expect(p.connectedThrough, isNull);
      expect(p.about, isNull);
      expect(p.education, isNull);
      expect(p.hasConnection, isFalse);
    });

    test('throws FormatException when name is missing', () {
      expect(
        () => Profile.fromJson({'id': 1, 'name': null}),
        throwsFormatException,
      );
    });
  });

  group('filterProfiles', () {
    final profiles = [
      _profile(1, 'Ananya Sharma', 'Noida'),
      _profile(2, 'Rohan Agarwal', 'Delhi'),
      _profile(3, 'Mohit Saxena', 'Noida'),
      _profile(4, 'No City Person', null),
    ];

    test('blank query returns everyone', () {
      expect(filterProfiles(profiles, '  '), hasLength(4));
    });

    test('matches name case-insensitively', () {
      final result = filterProfiles(profiles, 'ANANYA');
      expect(result.map((p) => p.id), [1]);
    });

    test('matches city case-insensitively', () {
      final result = filterProfiles(profiles, 'noida');
      expect(result.map((p) => p.id), [1, 3]);
    });

    test('returns empty list when nothing matches', () {
      expect(filterProfiles(profiles, 'zzz'), isEmpty);
    });
  });
}