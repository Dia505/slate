import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/view_model/post_view_model.dart';
import 'package:slate/view_model/user_view_model.dart';

class MockUserViewModel extends Mock implements UserViewModel {}

class MockPostViewModel extends Mock implements PostViewModel {}

void main() {
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Profile Screen Test', (WidgetTester tester) async {
    // Mock the dependencies
    final userViewModel = MockUserViewModel();
    final postViewModel = MockPostViewModel();

    // Provide mocked dependencies using ValueProvider
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserViewModel()),
              ChangeNotifierProvider(create: (_) => PostViewModel()),
            ],
            child: ProfileScreen(),
          ),
        ),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
        },
      ),
    );

    // Verify that the profile screen is rendered
    expect(find.byType(ProfileScreen), findsOneWidget);

    // Mock user data
    final mockUser = UserModel(
      fullname: 'John Doe',
      username: 'johndoe',
      bio: 'Sample bio',
    );

    // Mock user view model response
    when(userViewModel.fetchUserDataById(any as String)).thenAnswer((_) async => mockUser); // Explicitly specify the type

    // Simulate user login
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('userId', 'testUserId');

    // Rebuild the widget after login
    await tester.pump();

    // Verify that the user data is displayed on the screen
    expect(find.text(mockUser.fullname!), findsOneWidget);
    expect(find.text(mockUser.username!), findsOneWidget);
    expect(find.text(mockUser.bio!), findsOneWidget);

    // Verify that the "Logout" button is present
    expect(find.text('Logout'), findsOneWidget);

    // Verify that user posts are being fetched
    verify(postViewModel.fetchUserPosts()).called(1);
  });
}
