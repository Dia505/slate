import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:slate/navigation/navigation.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/home/home_screen.dart';
import 'package:slate/search/search_screen.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Initialize Firebase before running tests
  setUpAll(() async {
    // Ensure Firebase is initialized
    await Firebase.initializeApp();
  });

  testWidgets('Navigation Screen Test', (WidgetTester tester) async {
    final MockNavigatorObserver navigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: NavigationScreen(),
      navigatorObservers: [navigatorObserver],
    ));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SearchScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsNothing);

    // Tap on the home button by finding it using its type
    await tester.tap(find.byType(InkWell).at(0)); // Assuming it's the first InkWell
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SearchScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsNothing);

    // Tap on the search button by finding it using its type
    await tester.tap(find.byType(InkWell).at(1)); // Assuming it's the second InkWell
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsNothing);

    // Tap on the profile button by finding it using its type
    await tester.tap(find.byType(InkWell).at(2)); // Assuming it's the second InkWell
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(SearchScreen), findsNothing);
  });
}
