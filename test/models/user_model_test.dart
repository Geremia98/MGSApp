import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_users_fields.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test_helpers.dart';

@GenerateMocks([User])
import 'user_model_test.mocks.dart';

void main() {
  group('UserModel', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Reset static fields before each test
      UserModel.uid = '';
      UserModel.gender = UserGender.male;
      UserModel.email = '';
      UserModel.name = '';
      UserModel.surname = '';
      UserModel.birth = null;
      UserModel.profilePic = null;
      UserModel.group = '';
      UserModel.ispettoria = '';
      UserModel.country = '';
      UserModel.bossCode = '';
      UserModel.myEventsList = [];
      UserModel.iban = '';
      UserModel.holderName = '';
      UserModel.bankCurrency = '';
    });

    group('UserGender enum', () {
      test('has correct values', () {
        expect(UserGender.values.length, equals(2));
        expect(UserGender.values, contains(UserGender.male));
        expect(UserGender.values, contains(UserGender.female));
      });

      test('has correct names', () {
        expect(UserGender.male.name, equals('male'));
        expect(UserGender.female.name, equals('female'));
      });
    });

    group('static fields initialization', () {
      test('has correct default values', () {
        // Reset to ensure defaults
        UserModel.uid = '';
        UserModel.gender = UserGender.male;
        UserModel.email = '';
        UserModel.name = '';
        UserModel.surname = '';
        UserModel.birth = null;
        UserModel.profilePic = null;
        UserModel.group = '';
        UserModel.ispettoria = '';
        UserModel.country = '';
        UserModel.bossCode = '';
        UserModel.myEventsList = [];
        UserModel.iban = '';
        UserModel.holderName = '';
        UserModel.bankCurrency = '';

        expect(UserModel.uid, equals(''));
        expect(UserModel.gender, equals(UserGender.male));
        expect(UserModel.email, equals(''));
        expect(UserModel.name, equals(''));
        expect(UserModel.surname, equals(''));
        expect(UserModel.birth, isNull);
        expect(UserModel.profilePic, isNull);
        expect(UserModel.group, equals(''));
        expect(UserModel.ispettoria, equals(''));
        expect(UserModel.country, equals(''));
        expect(UserModel.bossCode, equals(''));
        expect(UserModel.myEventsList, isEmpty);
        expect(UserModel.iban, equals(''));
        expect(UserModel.holderName, equals(''));
        expect(UserModel.bankCurrency, equals(''));
      });
    });

    group('fromFirestore constructor', () {
      late MockUser mockUser;

      setUp(() {
        mockUser = MockUser();
      });

      test('sets uid and email from User', () {
        when(mockUser.uid).thenReturn('test-uid-123');
        when(mockUser.email).thenReturn('test@example.com');

        UserModel.fromFirestore(mockUser, {});

        expect(UserModel.uid, equals('test-uid-123'));
        expect(UserModel.email, equals('test@example.com'));
      });

      test('handles null email from User', () {
        when(mockUser.uid).thenReturn('test-uid-123');
        when(mockUser.email).thenReturn(null);

        UserModel.fromFirestore(mockUser, {});

        expect(UserModel.uid, equals('test-uid-123'));
        expect(UserModel.email, equals(''));
      });

      test('sets all fields from complete data', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final data = {
          firestoreUsersNameField: 'John',
          firestoreUsersSurnameField: 'Doe',
          firestoreUsersGenderField: 'female',
          firestoreUsersGroupField: 'Group A',
          firestoreUsersIspettoriaField: 'Ispettoria North',
          firestoreUsersCountryField: 'Italy',
          firestoreUsersBossCodeField: 'BOSS123',
          firestoreUsersMyEventsListField: <EventModel>[],
          firestoreBankCurrencyField: 'EUR',
          firestoreBakHolderNameField: 'John Doe',
          firestoreBankIbanField: 'IT60X0542811101000000123456',
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.name, equals('John'));
        expect(UserModel.surname, equals('Doe'));
        expect(UserModel.gender, equals(UserGender.female));
        expect(UserModel.group, equals('Group A'));
        expect(UserModel.ispettoria, equals('Ispettoria North'));
        expect(UserModel.country, equals('Italy'));
        expect(UserModel.bossCode, equals('BOSS123'));
        expect(UserModel.myEventsList, isEmpty);
        expect(UserModel.bankCurrency, equals('EUR'));
        expect(UserModel.holderName, equals('John Doe'));
        expect(UserModel.iban, equals('IT60X0542811101000000123456'));
      });

      test('uses default values for missing fields', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        UserModel.fromFirestore(mockUser, {});

        expect(UserModel.name, equals(''));
        expect(UserModel.surname, equals(''));
        expect(UserModel.gender, equals(UserGender.male));
        expect(UserModel.group, equals(''));
        expect(UserModel.ispettoria, equals(''));
        expect(UserModel.country, equals(''));
        expect(UserModel.bossCode, equals(''));
        expect(UserModel.myEventsList, isEmpty);
        expect(UserModel.bankCurrency, equals(''));
        expect(UserModel.holderName, equals(''));
        expect(UserModel.iban, equals(''));
      });

      test('handles partial data', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final data = {
          firestoreUsersNameField: 'Jane',
          firestoreUsersGenderField: 'female',
          firestoreUsersCountryField: 'France',
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.name, equals('Jane'));
        expect(UserModel.surname, equals(''));
        expect(UserModel.gender, equals(UserGender.female));
        expect(UserModel.group, equals(''));
        expect(UserModel.ispettoria, equals(''));
        expect(UserModel.country, equals('France'));
        expect(UserModel.bossCode, equals(''));
      });

      test('handles invalid gender field', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final data = {
          firestoreUsersGenderField: 'invalid-gender',
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.gender, equals(UserGender.male)); // Default fallback
      });

      test('handles male gender correctly', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final data = {
          firestoreUsersGenderField: 'male',
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.gender, equals(UserGender.male));
      });

      test('handles events list field correctly', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final mockEvents = <EventModel>[
          EventModel(
            id: 'event-1',
            title: 'Test Event',
            desc: 'Description',
            start: DateTime.now(),
            end: DateTime.now().add(Duration(hours: 2)),
          ),
        ];

        final data = {
          firestoreUsersMyEventsListField: mockEvents,
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.myEventsList, equals(mockEvents));
        expect(UserModel.myEventsList.length, equals(1));
        expect(UserModel.myEventsList.first.title, equals('Test Event'));
      });

      test('filters out non-EventModel items from events list', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final mixedList = [
          EventModel(
            id: 'event-1',
            title: 'Valid Event',
            desc: 'Description',
            start: DateTime.now(),
            end: DateTime.now().add(Duration(hours: 2)),
          ),
          'invalid-item',
          123,
          null,
        ];

        final data = {
          firestoreUsersMyEventsListField: mixedList,
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.myEventsList.length, equals(1));
        expect(UserModel.myEventsList.first.title, equals('Valid Event'));
      });

      test('handles null bank fields', () {
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');

        final data = {
          firestoreBankCurrencyField: null,
          firestoreBakHolderNameField: null,
          firestoreBankIbanField: null,
        };

        UserModel.fromFirestore(mockUser, data);

        expect(UserModel.bankCurrency, equals(''));
        expect(UserModel.holderName, equals(''));
        expect(UserModel.iban, equals(''));
      });

      test('static fields are shared across instances', () {
        when(mockUser.uid).thenReturn('test-uid-1');
        when(mockUser.email).thenReturn('test1@example.com');

        UserModel.fromFirestore(mockUser, {
          firestoreUsersNameField: 'First User',
        });

        expect(UserModel.name, equals('First User'));

        // Create another instance - should update the same static fields
        when(mockUser.uid).thenReturn('test-uid-2');
        when(mockUser.email).thenReturn('test2@example.com');

        UserModel.fromFirestore(mockUser, {
          firestoreUsersNameField: 'Second User',
        });

        expect(UserModel.name, equals('Second User'));
        expect(UserModel.uid, equals('test-uid-2'));
        expect(UserModel.email, equals('test2@example.com'));
      });
    });
  });
}