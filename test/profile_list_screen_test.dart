import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nada/core/app_exception.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/screens/profile_details_screen.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_list_skeleton.dart';

import 'helpers/test_helpers.dart';

void main() {
  final searchField = find.byKey(const Key('search_field'));

  group('loading', () {
    testWidgets('shows a skeleton while fetching, then the profiles',
        (tester) async {
      final completer = Completer<List<Profile>>();
      final repo = FakeProfileRepository((_) => completer.future);

      await pumpListScreen(tester, repo);
      await tester.pump();

      expect(find.byType(ProfileListSkeleton), findsOneWidget);
      expect(cardFor(ananya), findsNothing);

      completer.complete(sampleProfiles);
      await tester.pumpAndSettle();

      expect(find.byType(ProfileListSkeleton), findsNothing);
      expect(cardFor(ananya), findsOneWidget);
    });

    testWidgets('renders every profile with name, age, city and connection',
        (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      for (final p in sampleProfiles) {
        expect(cardFor(p), findsOneWidget);
      }
      expect(find.text('Ananya Sharma'), findsOneWidget);
      expect(find.text('27'), findsOneWidget);
      expect(
        find.text('Your cousin Nikhil knows her brother.'),
        findsOneWidget,
      );
      expect(find.text('4 PROFILES'), findsOneWidget);
    });
  });

  group('search', () {
    testWidgets('filters by name, ignoring case', (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'ANANYA');
      await tester.pump();

      expect(cardFor(ananya), findsOneWidget);
      expect(cardFor(rohan), findsNothing);
      expect(cardFor(mohit), findsNothing);
      expect(cardFor(nikhil), findsNothing);
      expect(find.text('1 OF 4 PROFILES'), findsOneWidget);
    });

    testWidgets('filters by city, ignoring case', (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'nOiDa');
      await tester.pump();

      expect(cardFor(ananya), findsOneWidget);
      expect(cardFor(mohit), findsOneWidget);
      expect(cardFor(rohan), findsNothing);
      expect(cardFor(nikhil), findsNothing);
      expect(find.text('2 OF 4 PROFILES'), findsOneWidget);
    });

    testWidgets('does not refetch while typing', (tester) async {
      final repo = FakeProfileRepository.returning(sampleProfiles);
      await pumpListScreen(tester, repo);
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'n');
      await tester.pump();
      await tester.enterText(searchField, 'no');
      await tester.pump();
      await tester.enterText(searchField, 'noi');
      await tester.pump();

      expect(repo.callCount, 1);
    });

    testWidgets('clear button resets the field and the list', (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      // No clear button while the field is empty.
      expect(find.byKey(const Key('search_clear')), findsNothing);

      await tester.enterText(searchField, 'delhi');
      await tester.pump();
      expect(cardFor(ananya), findsNothing);

      await tester.tap(find.byKey(const Key('search_clear')));
      await tester.pump();

      expect(find.byKey(const Key('search_clear')), findsNothing);
      for (final p in sampleProfiles) {
        expect(cardFor(p), findsOneWidget);
      }
    });
  });

  group('empty state', () {
    testWidgets('an unmatched query shows "No profiles match"',
        (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'zzz-no-such-person');
      await tester.pump();

      expect(find.text('No profiles match'), findsOneWidget);
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
      expect(cardFor(ananya), findsNothing);
    });

    testWidgets('"Clear search" brings the list back', (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'zzz');
      await tester.pump();
      await tester.tap(find.byKey(const Key('clear_search_button')));
      await tester.pump();

      expect(find.text('No profiles match'), findsNothing);
      expect(cardFor(ananya), findsOneWidget);
      expect(tester.widget<TextField>(searchField).controller!.text, isEmpty);
    });
  });

  group('error and retry', () {
    testWidgets('a failed fetch shows the error state with a message',
        (tester) async {
      final repo = FakeProfileRepository(
        (_) async => throw const AppException("Couldn't reach the server."),
      );
      await pumpListScreen(tester, repo);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_state')), findsOneWidget);
      expect(find.text("Couldn't reach the server."), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);
      expect(cardFor(ananya), findsNothing);
    });

    testWidgets('Retry performs a real refetch and recovers', (tester) async {
      final repo = FakeProfileRepository((attempt) async {
        if (attempt == 0) throw const AppException('Offline.');
        return sampleProfiles;
      });
      await pumpListScreen(tester, repo);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('error_state')), findsOneWidget);
      expect(repo.callCount, 1);

      await tester.tap(find.byKey(const Key('retry_button')));
      await tester.pumpAndSettle();

      expect(repo.callCount, 2);
      expect(find.byKey(const Key('error_state')), findsNothing);
      expect(cardFor(ananya), findsOneWidget);
    });

    testWidgets('Retry that fails again stays on the error state',
        (tester) async {
      final repo = FakeProfileRepository(
        (_) async => throw const AppException('Still offline.'),
      );
      await pumpListScreen(tester, repo);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('retry_button')));
      await tester.pumpAndSettle();

      expect(repo.callCount, 2);
      expect(find.byKey(const Key('error_state')), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('tapping a card opens details, back returns to the list',
        (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.tap(cardFor(ananya));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDetailsScreen), findsOneWidget);
      expect(find.byKey(const Key('connection_card')), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDetailsScreen), findsNothing);
      expect(cardFor(ananya), findsOneWidget);
    });

    testWidgets('search text survives going to details and back',
        (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(sampleProfiles),
      );
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'noida');
      await tester.pump();
      await tester.tap(cardFor(mohit));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(searchField).controller!.text, 'noida');
      expect(cardFor(rohan), findsNothing);
      expect(cardFor(mohit), findsOneWidget);
    });
  });

  group('awkward data', () {
    testWidgets('every edge-case profile renders without exceptions',
        (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(edgeCaseProfiles),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Rajeshwari Nandini Mishra Chaturvedi'), findsOneWidget);
      expect(find.text('आपके मौसा जी के बैंक के सहकर्मी।'), findsOneWidget);
      // Nikhil has no connection: plain message, no "null" text anywhere.
      expect(find.text('No connection yet'), findsOneWidget);
      expect(find.textContaining('null'), findsNothing);
    });

    testWidgets('large system text size does not overflow', (tester) async {
      await pumpListScreen(
        tester,
        FakeProfileRepository.returning(edgeCaseProfiles),
        textScale: 2.0,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}