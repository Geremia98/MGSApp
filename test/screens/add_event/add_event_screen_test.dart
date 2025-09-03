import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_screen.dart';
import 'package:mgs_app2/screens/add_event/progress_bar.dart';
import 'package:mgs_app2/screens/add_event/add_event_navigator.dart';
import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import '../../test_helpers.dart';

void main() {
  group('AddEventScreen', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.uid = 'test_uid';
    });

    testWidgets('renders correctly with authorized user', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        expect(find.byType(AddEventScreen), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('shows access denied dialog for unauthorized user', (WidgetTester tester) async {
      UserModel.bossCode = '';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        expect(find.text('Access Denied'), findsOneWidget);
        expect(find.text('You are not authorized to create an event.'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays required components for authorized user', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        expect(find.byType(BackButtonAppBar), findsOneWidget);
        expect(find.byType(AddEventProgressBar), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
        expect(find.byType(AddEventNavigator), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button is present', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
        expect(find.byType(BackButtonAppBar), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('PageView has non-scrollable physics', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        final pageView = tester.widget<PageView>(find.byType(PageView));
        expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has scaffold and safe area', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Positioned), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('unauthorized user sees dialog and can dismiss it', (WidgetTester tester) async {
      UserModel.bossCode = '';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        // Dialog should be present
        expect(find.text('Access Denied'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
        
        // Should be able to tap OK
        await tester.tap(find.text('OK'));
        await tester.pump();
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('creates controller and progress bar integration', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        // Verify the controller is properly integrated by checking components that use it
        expect(find.byType(AddEventProgressBar), findsOneWidget);
        expect(find.byType(AddEventNavigator), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('basic widget structure is present', (WidgetTester tester) async {
      UserModel.bossCode = 'authorized_code';
      
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();

        expect(find.byType(AddEventScreen), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(SizedBox), findsWidgets);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles authorization correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test unauthorized state
        UserModel.bossCode = '';
        
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();
        expect(find.text('Access Denied'), findsOneWidget);
        
        // Clean up dialog
        await tester.tap(find.text('OK'));
        await tester.pump();
        
        // Test authorized state
        UserModel.bossCode = 'valid_code';
        
        await tester.pumpWidget(
          MaterialApp(
            home: AddEventScreen(),
          ),
        );

        await tester.pump();
        expect(find.byType(AddEventProgressBar), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}