import 'package:flutter_test/flutter_test.dart';

import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';

void main() {
  group('ordinal', () {
    test('basic suffixes', () {
      expect(ordinal(1), '1st');
      expect(ordinal(2), '2nd');
      expect(ordinal(3), '3rd');
      expect(ordinal(4), '4th');
    });

    test('teens use th', () {
      expect(ordinal(11), '11th');
      expect(ordinal(12), '12th');
      expect(ordinal(13), '13th');
    });

    test('larger numbers', () {
      expect(ordinal(21), '21st');
      expect(ordinal(22), '22nd');
      expect(ordinal(101), '101st');
    });
  });

  group('initialsOf', () {
    test('two words', () => expect(initialsOf('Ananya Sharma'), 'AS'));

    test('uses first and last word of a long name', () {
      expect(initialsOf('Rajeshwari Nandini Mishra Chaturvedi'), 'RC');
    });

    test('single word', () => expect(initialsOf('Kabir'), 'K'));

    test('Devanagari', () => expect(initialsOf('आपके मौसा'), 'आम'));

    test('blank falls back to ?', () => expect(initialsOf('   '), '?'));
  });

  group('joinNonEmpty', () {
    test('skips null and blank parts', () {
      expect(joinNonEmpty(['Delhi', null, '  ', 'CA']), 'Delhi · CA');
    });

    test('returns null when nothing is left', () {
      expect(joinNonEmpty([null, ' ']), isNull);
    });
  });

  group('resultsLabel', () {
    test('no query shows the total', () {
      expect(resultsLabel(shown: 24, total: 24, query: ''), '24 profiles');
    });

    test('query shows shown of total', () {
      expect(resultsLabel(shown: 3, total: 24, query: 'noida'), '3 of 24 profiles');
    });
  });

  group('profileFields', () {
    test('skips absent values and ends with the profile id', () {
      final p = Profile.fromJson({
        'id': 6,
        'name': 'Dev Chaudhary',
        'age': 28,
        'gender': 'M',
        'city': 'Faridabad',
        'degree': null,
      });

      final labels = profileFields(p).map((f) => f.label).toList();

      expect(labels, ['Age', 'Gender', 'City', 'Profile ID']);
    });

    test('maps gender codes to words', () {
      final p = Profile.fromJson({'id': 1, 'name': 'A', 'gender': 'F'});

      expect(
        profileFields(p).firstWhere((f) => f.label == 'Gender').value,
        'Female',
      );
    });

    test('shows fields the app does not know about yet', () {
      final p = Profile.fromJson({
        'id': 1,
        'name': 'A',
        'marital_status': 'Never married',
        'verified': null,
      });

      final fields = profileFields(p);

      expect(
        fields.any(
          (f) => f.label == 'Marital status' && f.value == 'Never married',
        ),
        isTrue,
      );
      expect(fields.any((f) => f.label == 'Verified'), isFalse);
    });
  });
}