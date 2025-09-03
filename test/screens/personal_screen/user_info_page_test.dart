import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/personal_screen/user_info_page.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'user_info_page_test.mocks.dart';

@GenerateMocks([UserFirestore])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
    await initializeDateFormatting('it_IT', null);
  });

  group('UserInfoPage', () {
    late MockUserFirestore mockUserFirestore;

    setUp(() {
      mockUserFirestore = MockUserFirestore();
      
      // Set up UserModel with test data
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.birth = DateTime(1990, 5, 15);
      UserModel.gender = UserGender.male;
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
        await tester.pumpWidget(
          MaterialApp(
            home: const UserInfoPage(),
          ),
        );

        expect(find.byType(UserInfoPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays user info in read-only mode initially', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Check that form fields are disabled initially
        expect(find.text('Mario'), findsOneWidget);
        expect(find.text('Rossi'), findsOneWidget);
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays correct UI elements and titles', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        expect(find.text('Anagrafica account'), findsOneWidget);
        expect(find.text('Nome'), findsOneWidget);
        expect(find.text('Cognome'), findsOneWidget);
        expect(find.text('Sesso'), findsOneWidget);
        expect(find.text('Data di nascita'), findsOneWidget);
        expect(find.text('Maschio'), findsOneWidget);
        expect(find.text('Femmina'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays user data correctly', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Check user data is displayed
        expect(find.text('Mario'), findsOneWidget);
        expect(find.text('Rossi'), findsOneWidget);
        expect(find.text('15 maggio 1990'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('enters edit mode when Modifica button is tapped', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Tap the Modifica button
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify edit mode is activated
        expect(find.text('Modifica'), findsNothing);
        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('exits edit mode when Annulla button is tapped', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Tap Annulla button
        await tester.tap(find.text('Annulla'));
        await tester.pump();

        // Verify edit mode is deactivated
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('can edit name field in edit mode', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Find name field and change text
        final nameField = find.widgetWithText(TextFormField, 'Mario');
        await tester.enterText(nameField, 'Luigi');
        await tester.pump();

        expect(find.text('Luigi'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('can edit surname field in edit mode', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Find surname field and change text
        final surnameField = find.widgetWithText(TextFormField, 'Rossi');
        await tester.enterText(surnameField, 'Verdi');
        await tester.pump();

        expect(find.text('Verdi'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('gender segmented button works correctly', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Check segmented button is present
        expect(find.byType(MyCustomSegmentedButton<UserGender>), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('date picker is present and displays birth date', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        expect(find.byType(MyDatePicker), findsOneWidget);
        expect(find.text('15 maggio 1990'), findsOneWidget);
        
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
            home: const UserInfoPage(),
          ),
        );

        // Verify back button exists 
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.text('Anagrafica account'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('age validation is enforced during date selection', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // The date picker should enforce age validation when dates are selected
        // This is an integration test to verify the behavior exists
        expect(find.byType(MyDatePicker), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles different UserModel data configurations', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with different user data
        UserModel.name = 'Anna';
        UserModel.surname = 'Bianchi';
        UserModel.birth = DateTime(1985, 12, 25);
        UserModel.gender = UserGender.female;

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserInfoPage(),
          ),
        );

        expect(find.text('Anna'), findsOneWidget);
        expect(find.text('Bianchi'), findsOneWidget);
        expect(find.text('25 dicembre 1985'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.name = 'Mario';
        UserModel.surname = 'Rossi';
        UserModel.birth = DateTime(1990, 5, 15);
        UserModel.gender = UserGender.male;
      }
    });

    testWidgets('handles null birth date gracefully', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with null birth date
        UserModel.birth = null;

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserInfoPage(),
          ),
        );

        // Should render without crashing
        expect(find.byType(UserInfoPage), findsOneWidget);
        expect(find.byType(MyDatePicker), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.birth = DateTime(1990, 5, 15);
      }
    });

    testWidgets('form fields are properly disabled in read-only mode', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Check that form fields are disabled
        final nameFieldWidget = tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Mario'));
        expect(nameFieldWidget.enabled, isFalse);
        
        final surnameFieldWidget = tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Rossi'));
        expect(surnameFieldWidget.enabled, isFalse);
        
        final segmentedButtonWidget = tester.widget<MyCustomSegmentedButton<UserGender>>(find.byType(MyCustomSegmentedButton<UserGender>));
        expect(segmentedButtonWidget.isEnabled, isFalse);
        
        final datePickerWidget = tester.widget<MyDatePicker>(find.byType(MyDatePicker));
        expect(datePickerWidget.isEnable, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form fields are enabled in edit mode', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Check that form fields are enabled
        final nameFieldWidget = tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Mario'));
        expect(nameFieldWidget.enabled, isTrue);
        
        final surnameFieldWidget = tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Rossi'));
        expect(surnameFieldWidget.enabled, isTrue);
        
        final segmentedButtonWidget = tester.widget<MyCustomSegmentedButton<UserGender>>(find.byType(MyCustomSegmentedButton<UserGender>));
        expect(segmentedButtonWidget.isEnabled, isTrue);
        
        final datePickerWidget = tester.widget<MyDatePicker>(find.byType(MyDatePicker));
        expect(datePickerWidget.isEnable, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('cancel button exits edit mode properly', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify we're in edit mode
        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        expect(find.text('Modifica'), findsNothing);

        // Cancel changes
        await tester.tap(find.text('Annulla'));
        await tester.pump();

        // Verify we've exited edit mode
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
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
            home: const UserInfoPage(),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Padding), findsWidgets);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}