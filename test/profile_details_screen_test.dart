import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nada/features/profiles/presentation/widgets/degree_badge.dart';

import 'helpers/test_helpers.dart';

void main() {
  testWidgets('shows the connection prominently and the other fields',
      (tester) async {
    await pumpDetailsScreen(tester, ananya);

    expect(find.byKey(const Key('connection_card')), findsOneWidget);
    expect(find.text('CONNECTED THROUGH'), findsOneWidget);
    expect(
      find.text('Your cousin Nikhil knows her brother.'),
      findsOneWidget,
    );
    expect(find.byType(DegreeBadge), findsOneWidget);

    expect(find.text('Ananya Sharma'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('Noida'), findsWidgets);
    expect(find.text('Brahmin'), findsOneWidget);
    expect(find.text('Product designer at a fintech'), findsOneWidget);
    expect(find.text('B.Des, NIFT Delhi'), findsOneWidget);
    expect(find.byKey(const Key('about_card')), findsOneWidget);
  });

  testWidgets('a profile with no connection says so plainly', (tester) async {
    await pumpDetailsScreen(tester, nikhil);

    expect(find.byKey(const Key('no_connection_card')), findsOneWidget);
    expect(find.byKey(const Key('connection_card')), findsNothing);
    expect(find.text('No connection yet'), findsOneWidget);
    // Null degree: no badge and no empty row.
    expect(find.byType(DegreeBadge), findsNothing);
    expect(find.text('DEGREE'), findsNothing);
    // Other fields still show.
    expect(find.byKey(const Key('about_card')), findsOneWidget);
    expect(find.textContaining('null'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a missing field is hidden, not shown as a placeholder',
      (tester) async {
    await pumpDetailsScreen(tester, dev);

    expect(find.text('EDUCATION'), findsNothing);
    expect(find.text('PROFESSION'), findsOneWidget);
    expect(find.textContaining('null'), findsNothing);
    expect(find.textContaining('N/A'), findsNothing);
  });

  testWidgets('a null "about" hides the about section', (tester) async {
    await pumpDetailsScreen(tester, vikram);

    expect(find.byKey(const Key('about_card')), findsNothing);
    expect(find.text('ABOUT'), findsNothing);
    expect(find.byKey(const Key('connection_card')), findsOneWidget);
  });

  testWidgets('Hindi text renders in connection and about', (tester) async {
    await pumpDetailsScreen(tester, aditya);

    expect(find.text('आपके मौसा जी के बैंक के सहकर्मी।'), findsOneWidget);
    expect(
      find.text('लखनऊ में बैंक में पीओ, तबादले वाली नौकरी है, प्रेमचंद पढ़ते हैं।'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('long "about" text shows in full without overflow',
      (tester) async {
    await pumpDetailsScreen(tester, kabir);

    expect(find.textContaining('argue about films'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('very long name wraps without overflow', (tester) async {
    await pumpDetailsScreen(tester, rajeshwari);

    expect(find.text('Rajeshwari Nandini Mishra Chaturvedi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every edge-case profile survives 2x text scale',
      (tester) async {
    for (final profile in edgeCaseProfiles) {
      await pumpDetailsScreen(tester, profile, textScale: 2.0);
      expect(
        tester.takeException(),
        isNull,
        reason: 'overflow or error for ${profile.name}',
      );
    }
  });
}