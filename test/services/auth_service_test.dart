import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';

import 'auth_service_test.mocks.dart';

// A mock BuildContext since signOut requires it, but doesn't use it.
class MockBuildContext extends Mock implements BuildContext {}

@GenerateMocks([FirebaseAuth, User, UserCredential])
void main() {
  group('FirebaseAuthService', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthService authService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      authService = FirebaseAuthService(auth: mockFirebaseAuth);
    });

    test('signOut successfully calls signOut on FirebaseAuth instance', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reload()).thenAnswer((_) async => {});

      // Act
      await authService.signOut(MockBuildContext());

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockUser.reload()).called(1);
    });

    group('signInWithEmailAndPassword', () {
      test('returns User on success', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password',
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);

        // Act
        final result = await authService.signInWithEmailAndPassword(
            'test@test.com', 'password');

        // Assert
        expect(result, isA<User>());
        expect(result, mockUser);
      });

      test('returns error string on FirebaseAuthException', () async {
        // Arrange
        final exception = FirebaseAuthException(code: 'user-not-found');
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password',
        )).thenThrow(exception);

        // Act
        final result = await authService.signInWithEmailAndPassword(
            'test@test.com', 'password');

        // Assert
        expect(result, isA<String>());
        expect(result, exception.toString());
      });
    });

    group('registerWithEmailAndPassword', () {
      test('returns User on success', () async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password',
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);

        // Act
        final result = await authService.registerWithEmailAndPassword(
            'test@test.com', 'password');

        // Assert
        expect(result, isA<User>());
        expect(result, mockUser);
      });

      test('returns error string on FirebaseAuthException', () async {
        // Arrange
        final exception = FirebaseAuthException(code: 'email-already-in-use');
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password',
        )).thenThrow(exception);

        // Act
        final result = await authService.registerWithEmailAndPassword(
            'test@test.com', 'password');

        // Assert
        expect(result, isA<String>());
        expect(result, exception.toString());
      });
    });

    group('User Status Getters', () {
      test('isUserLogged returns true when user is not null', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        expect(authService.isUserLogged(), isTrue);
      });

      test('isUserLogged returns false when user is null', () {
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        expect(authService.isUserLogged(), isFalse);
      });

      test('getCurrentUser returns the current user', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        expect(authService.getCurrentUser(), mockUser);
      });

      test('isUserEmailVerified returns true when user is verified', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.emailVerified).thenReturn(true);
        expect(authService.isUserEmailVerified(), isTrue);
      });

      test('isUserEmailVerified returns false when user is not verified', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.emailVerified).thenReturn(false);
        expect(authService.isUserEmailVerified(), isFalse);
      });
    });

    group('sendPasswordResetEmail', () {
      test('calls sendPasswordResetEmail on the auth instance', () async {
        // Arrange
        const email = 'test@test.com';
        when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((_) async => {});
        // Need to mock currentUser as null for this method to proceed
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = await authService.sendPasswordResetEmail(email);

        // Assert
        verify(mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
        expect(result, isTrue);
      });

       test('returns null if email is empty', () async {
        final result = await authService.sendPasswordResetEmail('');
        expect(result, isNull);
        verifyNever(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')));
      });

      test('returns null if user is already logged in', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        final result = await authService.sendPasswordResetEmail('test@test.com');
        expect(result, isNull);
        verifyNever(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')));
      });
    });

  });
}
