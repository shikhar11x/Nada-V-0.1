import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/application/profile_providers.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/data/profile_repository.dart';
import 'package:nada/features/profiles/presentation/screens/profile_details_screen.dart';
import 'package:nada/features/profiles/presentation/screens/profile_list_screen.dart';

// ---------------------------------------------------------------------------
// Fake repository: no network, fully controlled by the test.
// ---------------------------------------------------------------------------

typedef FetchHandler = Future<List<Profile>> Function(int attempt);

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.handler);

  /// Always succeeds with [profiles].
  FakeProfileRepository.returning(List<Profile> profiles)
      : handler = ((_) async => profiles);

  final FetchHandler handler;
  int callCount = 0;

  @override
  Future<List<Profile>> fetchProfiles() => handler(callCount++);
}

// ---------------------------------------------------------------------------
// Fixtures that mirror the shapes found in the real dataset.
// ---------------------------------------------------------------------------

final ananya = Profile.fromJson({
  'id': 1,
  'name': 'Ananya Sharma',
  'age': 27,
  'gender': 'F',
  'city': 'Noida',
  'community': 'Brahmin',
  'profession': 'Product designer at a fintech',
  'education': 'B.Des, NIFT Delhi',
  'degree': 1,
  'connected_through': 'Your cousin Nikhil knows her brother.',
  'about': 'Reads a book a week, runs on Sundays, wants to stay in NCR.',
});

final rohan = Profile.fromJson({
  'id': 2,
  'name': 'Rohan Agarwal',
  'age': 29,
  'gender': 'M',
  'city': 'Delhi',
  'community': 'Agarwal',
  'profession': 'Chartered accountant',
  'education': 'CA',
  'degree': 2,
  'connected_through': 'Your uncle Rajesh knows his father.',
  'about': 'Joint family in Lajpat Nagar, plays badminton, vegetarian.',
});

final mohit = Profile.fromJson({
  'id': 20,
  'name': 'Mohit Saxena',
  'age': 31,
  'gender': 'M',
  'city': 'Noida',
  'community': 'Kayastha',
  'profession': 'Product manager',
  'education': 'B.Tech, MBA',
  'degree': 1,
  'connected_through': "Your office friend Rahul's cousin.",
  'about': 'Works at an edtech in Noida, plays guitar.',
});

/// degree and connected_through are both null.
final nikhil = Profile.fromJson({
  'id': 10,
  'name': 'Nikhil Yadav',
  'age': 29,
  'gender': 'M',
  'city': 'Varanasi',
  'community': 'Yadav',
  'profession': 'Assistant professor of history',
  'education': 'PhD, BHU',
  'degree': null,
  'connected_through': null,
  'about': 'Teaches at BHU, writes for a Hindi magazine.',
});

/// No "education" key at all.
final dev = Profile.fromJson({
  'id': 6,
  'name': 'Dev Chaudhary',
  'age': 28,
  'gender': 'M',
  'city': 'Faridabad',
  'community': 'Jat',
  'profession': 'Runs the family transport business',
  'degree': 1,
  'connected_through': 'His sister was at school with you.',
  'about': 'Family business in Faridabad, early riser, into cricket.',
});

/// "about" is null.
final vikram = Profile.fromJson({
  'id': 12,
  'name': 'Vikram Chopra',
  'age': 32,
  'gender': 'M',
  'city': 'Chandigarh',
  'community': 'Punjabi Khatri',
  'profession': 'Army officer, major',
  'education': 'NDA',
  'degree': 1,
  'connected_through': "Your brother's batchmate.",
  'about': null,
});

/// Very long "about".
final kabir = Profile.fromJson({
  'id': 4,
  'name': 'Kabir Khanna',
  'age': 30,
  'gender': 'M',
  'city': 'Gurugram',
  'community': 'Punjabi Khatri',
  'profession': 'Software engineer at a product company',
  'education': 'B.Tech, NIT Kurukshetra',
  'degree': 3,
  'connected_through': 'A friend of your office friend Priya.',
  'about':
      'Works hybrid from Gurugram three days a week, cooks dal makhani better '
          'than most restaurants, has driven to Spiti twice, and wants a partner '
          'who likes to travel, read, and argue about films without taking it '
          'personally.',
});

/// Very long name.
final rajeshwari = Profile.fromJson({
  'id': 13,
  'name': 'Rajeshwari Nandini Mishra Chaturvedi',
  'age': 28,
  'gender': 'F',
  'city': 'Kanpur',
  'community': 'Brahmin',
  'profession': 'Architect',
  'education': 'B.Arch',
  'degree': 3,
  'connected_through': 'Your dadi knows her grandmother from Kanpur.',
  'about': 'Own practice in Kanpur, sketches, wants a partner from UP.',
});

/// Hindi connection and about.
final aditya = Profile.fromJson({
  'id': 16,
  'name': 'Aditya Tiwari',
  'age': 27,
  'gender': 'M',
  'city': 'Lucknow',
  'community': 'Brahmin',
  'profession': 'Bank probationary officer',
  'education': 'B.Com',
  'degree': 2,
  'connected_through': 'आपके मौसा जी के बैंक के सहकर्मी।',
  'about': 'लखनऊ में बैंक में पीओ, तबादले वाली नौकरी है, प्रेमचंद पढ़ते हैं।',
});

/// Small list used by the list-screen tests.
final sampleProfiles = [ananya, rohan, mohit, nikhil];

/// Every awkward shape in one list.
final edgeCaseProfiles = [
  ananya,
  kabir,
  dev,
  nikhil,
  vikram,
  rajeshwari,
  aditya,
];

// ---------------------------------------------------------------------------
// Pump helpers
// ---------------------------------------------------------------------------

/// Tall surface so lazy lists build every card, no scrolling needed in tests.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(600, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _wrap(Widget home, double textScale) {
  return MaterialApp(
    theme: AppTheme.dark(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: home,
  );
}

/// Pumps the list screen with [repository] standing in for the network.
/// Does not settle, so tests can inspect the loading state.
Future<void> pumpListScreen(
  WidgetTester tester,
  ProfileRepository repository, {
  double textScale = 1.0,
}) async {
  useTallScreen(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: _wrap(const ProfileListScreen(), textScale),
    ),
  );
}

Future<void> pumpDetailsScreen(
  WidgetTester tester,
  Profile profile, {
  double textScale = 1.0,
}) async {
  useTallScreen(tester);
  await tester.pumpWidget(
    _wrap(ProfileDetailsScreen(profile: profile), textScale),
  );
  await tester.pumpAndSettle();
}

Finder cardFor(Profile p) => find.byKey(ValueKey('profile_card_${p.id}'));