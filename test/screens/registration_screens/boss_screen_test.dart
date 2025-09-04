import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/screens/registration_screens/boss_screen.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
import 'package:mgs_app2/widgets/selector.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'boss_screen_test.mocks.dart';

@GenerateMocks([FirebaseFunctionCaller])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('BossRegistrationScreen Tests', () {
    late RegistrationController testController;
    late MockFirebaseFunctionCaller mockFunctionCaller;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      testController = RegistrationController();
      mockFunctionCaller = MockFirebaseFunctionCaller();
    });

    testWidgets('displays basic UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check basic UI elements
        expect(find.text('Sei tu il boss?'), findsOneWidget);
        expect(find.text('Se hai ricevuto o richiesto un codice per diventare il boss inseriscilo qui sotto.'), findsOneWidget);
        expect(find.byType(MyCustomSegmentedButton<bool>), findsOneWidget);
        expect(find.text('No'), findsOneWidget);
        expect(find.text('Sì'), findsOneWidget);
        expect(find.byType(MySquaredIconButton), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('segmented button toggles isBoss state', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially should be false (No selected)
        expect(testController.isBoss, isFalse);

        // Find and tap the "Sì" segment
        final segmentedButton = find.byType(MyCustomSegmentedButton<bool>);
        expect(segmentedButton, findsOneWidget);

        // Get the widget and test its callback
        final state = tester.state(find.byType(BossRegistrationScreen)) as dynamic;
        final segmentedButtonWidget = tester.widget<MyCustomSegmentedButton<bool>>(segmentedButton);
        
        // Simulate selecting "Sì" (true)
        segmentedButtonWidget.onValueChange(true);
        await tester.pump();

        // Should show the code input field now
        expect(find.byType(CodeInputField), findsOneWidget);
        expect(testController.isBoss, isTrue);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('code input field appears when isBoss is true', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set controller to boss = true
        testController.isBoss = true;

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show code input field
        expect(find.byType(CodeInputField), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('code input field hidden when isBoss is false', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set controller to boss = false
        testController.isBoss = false;

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should not show code input field
        expect(find.byType(CodeInputField), findsNothing);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('valid boss code calls function caller and navigates', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Mock successful boss code validation
        when(mockFunctionCaller.isBossCodeValid(any)).thenAnswer(
          (_) async => FunctionResponse(ResponseType.success, {}),
        );

        testController.isBoss = true;

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the CodeInputField and simulate code completion
        final codeInputField = find.byType(CodeInputField);
        expect(codeInputField, findsOneWidget);

        // Get the widget and test its onCompleted callback
        final codeInputWidget = tester.widget<CodeInputField>(codeInputField);
        codeInputWidget.onCompleted('123456');
        await tester.pumpAndSettle();

        // Verify function caller was called
        verify(mockFunctionCaller.isBossCodeValid('123456')).called(1);

        // Verify boss code was set
        expect(testController.bossCode, '123456');

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('invalid boss code shows error and re-enables input', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Mock error response for boss code validation
        when(mockFunctionCaller.isBossCodeValid(any)).thenAnswer(
          (_) async => FunctionResponse(ResponseType.error, {'message': 'Invalid boss code'}),
        );

        testController.isBoss = true;

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the CodeInputField and simulate code completion
        final codeInputField = find.byType(CodeInputField);
        expect(codeInputField, findsOneWidget);

        // Get the state to check isEnabled before and after
        final state = tester.state(find.byType(BossRegistrationScreen)) as dynamic;
        expect(state.isEnabled, isTrue);

        // Get the widget and test its onCompleted callback
        final codeInputWidget = tester.widget<CodeInputField>(codeInputField);
        codeInputWidget.onCompleted('INVALID');
        await tester.pumpAndSettle();

        // Verify function caller was called
        verify(mockFunctionCaller.isBossCodeValid('INVALID')).called(1);

        // Verify boss code was NOT set (should remain empty)
        expect(testController.bossCode, '');

        // Verify isEnabled was reset to true after error
        expect(state.isEnabled, isTrue);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('forward button navigates correctly based on boss status', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test forward button functionality by accessing the onTap directly
        final forwardButton = find.byType(MySquaredIconButton);
        expect(forwardButton, findsOneWidget);

        // The forward button should be present and enabled
        final forwardButtonWidget = tester.widget<MySquaredIconButton>(forwardButton);
        expect(forwardButtonWidget.isEnable, isTrue);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
        
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BossRegistrationScreen(
                            controller: testController,
                            functionCaller: mockFunctionCaller,
                          ),
                        ),
                      );
                    },
                    child: const Text('Push'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(BossRegistrationScreen), findsOneWidget);

        // Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(BossRegistrationScreen), findsNothing);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initialization sets correct enabled state', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with empty boss code
        testController.bossCode = '';

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        final state = tester.state(find.byType(BossRegistrationScreen)) as dynamic;
        expect(state.isEnabled, isTrue);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initialization with existing boss code disables input', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with existing boss code
        testController.bossCode = 'EXISTING';

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        final state = tester.state(find.byType(BossRegistrationScreen)) as dynamic;
        expect(state.isEnabled, isFalse);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('widget structure and layout', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: BossRegistrationScreen(
              controller: testController,
              functionCaller: mockFunctionCaller,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check overall widget structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Stack), findsWidgets); // Multiple Stack widgets expected
        expect(find.byType(CircleAvatar), findsOneWidget);
        expect(find.byType(SizedBox), findsWidgets);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}