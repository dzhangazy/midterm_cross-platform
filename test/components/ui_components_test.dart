import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yummy/components/trip_card.dart';
import 'package:yummy/components/expense_tile.dart';
import 'package:yummy/components/post_card.dart';
import 'package:yummy/models/models.dart';

Widget wrapWithMaterial(Widget widget) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: widget,
    ),
  );
}

void main() {
  group('TripCard Widget Tests', () {
    final testTrip = Trip(
      title: 'Paris Vacation',
      destination: 'France',
      budget: 2000.0,
    );

    testWidgets('should display trip title and destination', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TripCard(trip: testTrip)));
      expect(find.text('Paris Vacation'), findsOneWidget);
      expect(find.text('France'), findsOneWidget);
    });
  });

  group('ExpenseTile Widget Tests', () {
    testWidgets('should call onChanged when checkbox is tapped', (WidgetTester tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithMaterial(
        ExpenseTile(
          title: 'Dinner',
          amount: 50.0,
          onChanged: (val) => changedValue = val,
        ),
      ));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(changedValue, isTrue);
    });
  });

  group('PostCard Widget Tests', () {
    final testPost = Post(
      id: '1',
      author: 'Stef P.',
      authorEmail: 'stef@yummy.com',
      profileImageUrl: '',
      comment: 'Testing my new post card!',
      timestamp: '5',
    );

    testWidgets('should display author and comment', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PostCard(post: testPost)));

      expect(find.text('Stef P.'), findsOneWidget);
      expect(find.text('Testing my new post card!'), findsOneWidget);
      // Проверка первой буквы в аватаре
      expect(find.text('S'), findsOneWidget);
    });
  });

  group('Golden Tests', () {
    testGoldens('TripCard states', (WidgetTester tester) async {
      final activeTrip = Trip(title: 'Active Trip', destination: 'Spain', budget: 1000);
      final completedTrip = Trip(title: 'Completed Trip', destination: 'Italy', budget: 1500, isCompleted: true);

      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario('Active', TripCard(trip: activeTrip, totalSpent: 500))
        ..addScenario('Completed', TripCard(trip: completedTrip, totalSpent: 1500));

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'trip_card_states');
    });

    testGoldens('PostCard Golden Test', (WidgetTester tester) async {
      final post = Post(
        id: '1',
        author: 'Alex Traveler',
        authorEmail: 'alex@yummy.com',
        profileImageUrl: '',
        comment: 'This is a very long comment to check if the post card handles multiline text correctly without overflowing.',
        timestamp: '12',
      );

      await tester.pumpWidgetBuilder(
        wrapWithMaterial(PostCard(post: post)),
        surfaceSize: const Size(400, 200),
      );
      await screenMatchesGolden(tester, 'post_card_visual');
    });
  });
}
