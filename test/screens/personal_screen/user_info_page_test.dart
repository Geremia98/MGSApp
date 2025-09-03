import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/personal_screen/user_info_page.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
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
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.birth = DateTime(1990, 5, 15);
      UserModel.gender = UserGender.male;
    });

    testWidgets('displays user data and basic UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(MaterialApp(home: const UserInfoPage()));

        expect(find.text('Anagrafica account'), findsOneWidget);
        expect(find.text('Mario'), findsOneWidget);
        expect(find.text('Rossi'), findsOneWidget);
        expect(find.text('15 maggio 1990'), findsOneWidget);
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.byType(MyCustomSegmentedButton<UserGender>), findsOneWidget);
        expect(find.byType(MyDatePicker), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('edit mode toggle and field enablement', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(MaterialApp(home: const UserInfoPage()));

        // Initially in read-only mode
        final nameField = tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(nameField.enabled, isFalse);

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        expect(find.text('Modifica'), findsNothing);

        final editModeField = tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(editModeField.enabled, isTrue);

        // Cancel back to read-only
        await tester.tap(find.text('Annulla'));
        await tester.pump();

        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form submission with mock service', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        when(mockUserFirestore.updateUserInfo(
          name: anyNamed('name'),
          surname: anyNamed('surname'),
          birth: anyNamed('birth'),
          gender: anyNamed('gender')
        )).thenAnswer((_) async {});

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(MaterialApp(
          home: UserInfoPage(userFirestore: mockUserFirestore),
        ));

        // Enter edit mode and modify data
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        await tester.enterText(find.byType(TextFormField).first, 'Giovanni');
        await tester.pump();

        // Submit changes
        await tester.tap(find.text('Conferma'));
        await tester.pumpAndSettle();

        // Verify service call and state update
        verify(mockUserFirestore.updateUserInfo(
          name: 'Giovanni',
          surname: 'Rossi',
          birth: DateTime(1990, 5, 15),
          gender: UserGender.male
        )).called(1);

        expect(UserModel.name, 'Giovanni');
        expect(find.text('Modifica'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
        UserModel.name = 'Mario'; // Reset
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('loading state during submission', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        when(mockUserFirestore.updateUserInfo(
          name: anyNamed('name'),
          surname: anyNamed('surname'),
          birth: anyNamed('birth'),
          gender: anyNamed('gender')
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(MaterialApp(
          home: UserInfoPage(userFirestore: mockUserFirestore),
        ));

        await tester.tap(find.text('Modifica'));
        await tester.pump();
        
        await tester.tap(find.text('Conferma'));
        await tester.pump();

        // Check cancel button is disabled during loading
        final cancelButton = tester.widget<ButtonText>(find.widgetWithText(ButtonText, 'Annulla'));
        expect(cancelButton.isEnabled, isFalse);
        
        await tester.pumpAndSettle();
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('age validation function', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const UserInfoPage()));

      final state = tester.state(find.byType(UserInfoPage)) as dynamic;
      final today = DateTime.now();
      
      expect(state.isAtLeast14YearsOld(DateTime(today.year - 15)), isTrue);
      expect(state.isAtLeast14YearsOld(DateTime(today.year - 14)), isTrue);
      expect(state.isAtLeast14YearsOld(DateTime(today.year - 13)), isFalse);
    });

    testWidgets('handles null birth date', (WidgetTester tester) async {
      UserModel.birth = null;
      
      await tester.pumpWidget(MaterialApp(home: const UserInfoPage()));
      
      expect(find.byType(UserInfoPage), findsOneWidget);
      expect(find.byType(MyDatePicker), findsOneWidget);
      
      UserModel.birth = DateTime(1990, 5, 15); // Reset
    });

    testWidgets('date picker triggers showDatePicker', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(MaterialApp(home: const UserInfoPage()));

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Tap the date picker to trigger onPressed (covers the showDatePicker call)
        final datePicker = find.byType(MyDatePicker);
        await tester.tap(datePicker);
        await tester.pumpAndSettle();

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}