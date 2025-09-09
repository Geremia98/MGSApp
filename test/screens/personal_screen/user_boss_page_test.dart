import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/personal_screen/user_boss_page.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'user_boss_page_test.mocks.dart';

@GenerateMocks([UserFirestore, FirebaseFunctionCaller])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
    await initializeDateFormatting('it_IT', null);
  });

  group('UserBossPage', () {
    late MockUserFirestore mockUserFirestore;
    late MockFirebaseFunctionCaller mockFirebaseFunctionCaller;

    setUp(() {
      mockUserFirestore = MockUserFirestore();
      mockFirebaseFunctionCaller = MockFirebaseFunctionCaller();
      
      // Reset UserModel
      UserModel.bossCode = '';
    });

    testWidgets('renders correctly with basic structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        expect(find.byType(UserBossPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byType(CodeInputField), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays correct title and instruction text', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        expect(find.text('Diventa Boss'), findsOneWidget);
        expect(find.text('Se hai ricevuto o richiesto un codice per diventare il boss inseriscilo qui sotto.'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has properly configured code input field', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final codeInputField = find.byType(CodeInputField);
        expect(codeInputField, findsOneWidget);
        
        final codeInputFieldWidget = tester.widget<CodeInputField>(codeInputField);
        expect(codeInputFieldWidget.length, 6);
        expect(codeInputFieldWidget.hasTitle, false);
        expect(codeInputFieldWidget.isEnabled, true);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button exists and is tappable', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final backButton = find.byType(GoBackButton);
        expect(backButton, findsOneWidget);
        
        // Verify back button can be tapped
        await tester.tap(backButton);
        await tester.pump();
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays instruction text with correct styling', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final instructionText = find.text('Se hai ricevuto o richiesto un codice per diventare il boss inseriscilo qui sotto.');
        expect(instructionText, findsOneWidget);
        
        final textWidget = tester.widget<Text>(instructionText);
        expect(textWidget.textAlign, TextAlign.center);
        expect(textWidget.style?.fontWeight, FontWeight.w700);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has proper layout structure and components', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Center), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('scaffold has proper key configuration', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final scaffold = find.byType(Scaffold);
        expect(scaffold, findsOneWidget);
        
        final scaffoldWidget = tester.widget<Scaffold>(scaffold);
        expect(scaffoldWidget.key, isA<GlobalKey<ScaffoldState>>());
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initially has enabled state', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final codeInputField = find.byType(CodeInputField);
        final codeInputFieldWidget = tester.widget<CodeInputField>(codeInputField);
        expect(codeInputFieldWidget.isEnabled, true);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('page layout is scrollable and responsive', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        final singleChildScrollView = find.byType(SingleChildScrollView);
        expect(singleChildScrollView, findsOneWidget);
        
        final scrollViewWidget = tester.widget<SingleChildScrollView>(singleChildScrollView);
        expect(scrollViewWidget.physics, isA<AlwaysScrollableScrollPhysics>());
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('contains all required UI components', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserBossPage(),
          ),
        );

        // Check for main components
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(2)); // Title and instruction text
        expect(find.byType(CodeInputField), findsOneWidget);
        
        // Check for proper text content
        expect(find.textContaining('Diventa Boss'), findsOneWidget);
        expect(find.textContaining('Se hai ricevuto o richiesto un codice'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}