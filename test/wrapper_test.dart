import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/theme.dart';
import 'package:mgs_app2/wrapper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'test_helpers.dart';

@GenerateMocks([fb.User])
import 'wrapper_test.mocks.dart';

// Mock translator for testing
class MockTranslator implements TranslatorLike {
  @override
  Future<void> load(Locale locale) async {}

  @override
  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {}
}

void main() {
  group('Wrapper', () {
    late MockUser mockUser;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      mockUser = MockUser();
      when(mockUser.email).thenReturn('test@example.com');
      // Reset UserModel
      UserModel.uid = '';
    });

    Widget createTestWidget({
      Stream<fb.User?>? userStreamOverride,
      Future<UserModel?>? userFutureOverride,
      TranslatorLike? translatorOverride,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('it', 'IT'),
        ],
        home: Wrapper(
          userStreamOverride: userStreamOverride,
          userFutureOverride: userFutureOverride,
          translatorOverride: translatorOverride,
        ),
      );
    }

    testWidgets('creates correctly with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(Wrapper), findsOneWidget);
    });

    testWidgets('is a StatefulWidget', (WidgetTester tester) async {
      const wrapper = Wrapper();
      expect(wrapper, isA<StatefulWidget>());
    });

    testWidgets('accepts optional parameters', (WidgetTester tester) async {
      const wrapper = Wrapper(
        userStreamOverride: null,
        userFutureOverride: null,
        translatorOverride: null,
      );

      expect(wrapper.userStreamOverride, isNull);
      expect(wrapper.userFutureOverride, isNull);
      expect(wrapper.translatorOverride, isNull);
    });

    testWidgets('contains Navigator widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(Navigator), findsWidgets);
    });

    testWidgets('shows loading state initially with stream controller', (WidgetTester tester) async {
      final StreamController<fb.User?> controller = StreamController<fb.User?>();
      
      await tester.pumpWidget(createTestWidget(
        userStreamOverride: controller.stream,
      ));

      await tester.pump();

      // Should show ThemeService with loading route
      expect(find.byType(ThemeService), findsOneWidget);
      
      controller.close();
    });

    testWidgets('sets UserModel.uid when user is present', (WidgetTester tester) async {
      const testUid = 'test-user-id';
      when(mockUser.uid).thenReturn(testUid);

      final StreamController<fb.User?> userController = StreamController<fb.User?>();
      
      await tester.pumpWidget(createTestWidget(
        userStreamOverride: userController.stream,
        userFutureOverride: Future.value(null),
      ));

      // Emit user
      userController.add(mockUser);
      await tester.pump();

      // Check that UserModel.uid was set
      expect(UserModel.uid, equals(testUid));
      
      userController.close();
    });

    testWidgets('shows loading while waiting for user model', (WidgetTester tester) async {
      const testUid = 'test-user-id';
      when(mockUser.uid).thenReturn(testUid);

      final StreamController<fb.User?> userController = StreamController<fb.User?>();
      final Completer<UserModel?> userModelCompleter = Completer<UserModel?>();
      
      await tester.pumpWidget(createTestWidget(
        userStreamOverride: userController.stream,
        userFutureOverride: userModelCompleter.future,
      ));

      // Emit user but don't complete user model future
      userController.add(mockUser);
      await tester.pump();

      // Should show ThemeService
      expect(find.byType(ThemeService), findsOneWidget);
      
      userController.close();
      userModelCompleter.complete(null);
    });

    testWidgets('creates default services when no overrides', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Should create default services and not throw errors
      expect(find.byType(Wrapper), findsOneWidget);
    });

    testWidgets('handles null values correctly', (WidgetTester tester) async {
      const wrapper = Wrapper(
        userStreamOverride: null,
        userFutureOverride: null,
        translatorOverride: null,
      );
      
      await tester.pumpWidget(MaterialApp(
        home: wrapper,
      ));

      expect(find.byType(Wrapper), findsOneWidget);
    });

    testWidgets('basic widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(Wrapper), findsOneWidget);
      expect(find.byType(Navigator), findsWidgets);
    });
  });
}