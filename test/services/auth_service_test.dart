import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';

import 'auth_service_test.mocks.dart';

// A mock BuildContext since signOut requires it, but doesn't use it.
class MockBuildContext extends Mock implements BuildContext {}

@GenerateMocks([FirebaseAuth, User, UserCredential, AuthCredential])
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

    test('getFirebaseInstance returns the auth instance', () {
      expect(authService.getFirebaseInstance(), mockFirebaseAuth);
    });

    group('signOut', () {
      test('successfully calls signOut and reloads user', () async {
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

      test('handles error when reload fails', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.reload()).thenThrow(Exception('Reload failed'));

        // Act
        await authService.signOut(MockBuildContext());

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
        verify(mockUser.reload()).called(1);
      });
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
        expect(result, 'Indirizzo email non registrato!');
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

      test('isUserEmailVerified returns false when user is not logged in', () {
        when(mockFirebaseAuth.currentUser).thenReturn(null);
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

      test('returns exception on failure', () async {
        const email = 'test@test.com';
        final exception = FirebaseAuthException(code: 'invalid-email');
        when(mockFirebaseAuth.sendPasswordResetEmail(email: email)).thenThrow(exception);
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await authService.sendPasswordResetEmail(email);

        expect(result, isA<FirebaseAuthException>());
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

    group('resetPassword', () {
      test('returns success message on success', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.updatePassword('newPass')).thenAnswer((_) async => {});

        final result = await authService.resetPassword('newPass');

        expect(result, 'Password aggiornata');
        verify(mockUser.updatePassword('newPass')).called(1);
      });

      test('returns error message on failure', () async {
        final exception = FirebaseAuthException(code: 'requires-recent-login');
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.updatePassword('newPass')).thenThrow(exception);

        final result = await authService.resetPassword('newPass');

        expect(result, isA<String>());
        expect(result, isNot('Password aggiornata'));
      });

      test('does nothing if user is not logged in', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        await authService.resetPassword('newPass');

        verifyNever(mockUser.updatePassword(any));
      });
    });

    group('resetEmail', () {
      test('returns success message on success', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.verifyBeforeUpdateEmail('new@email.com')).thenAnswer((_) async => {});
        when(mockUser.sendEmailVerification()).thenAnswer((_) async => {});

        final result = await authService.resetEmail('new@email.com');

        expect(result,
            'Ti abbiamo mandato un link di conferma sulla email new@email.com');
        verify(mockUser.verifyBeforeUpdateEmail('new@email.com')).called(1);
      });

      test('returns error message on failure', () async {
        final exception = FirebaseAuthException(code: 'email-already-in-use');
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.verifyBeforeUpdateEmail('new@email.com')).thenThrow(exception);

        final result = await authService.resetEmail('new@email.com');

        expect(result, isA<String>());
        expect(result, isNot(
            'Ti abbiamo mandato un link di conferma sulla email new@email.com'));
      });

      test('returns null if user is not logged in', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await authService.resetEmail('new@email.com');

        expect(result, isNull);
        verifyNever(mockUser.verifyBeforeUpdateEmail(any));
      });
    });

    group('Other Auth Methods', () {

      test('sendVerificationEmail calls sendEmailVerification on user', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.sendEmailVerification()).thenAnswer((_) async => {});

        await authService.sendVerificationEmail();

        verify(mockUser.sendEmailVerification()).called(1);
      });

       test('sendVerificationEmail does nothing if user is null', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        await authService.sendVerificationEmail();

        verifyNever(mockUser.sendEmailVerification());
      });

      test('listenAuthStatus returns authStateChanges stream', () {
        final controller = StreamController<User?>();
        when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => controller.stream);

        final result = authService.listenAuthStatus();

        expect(result, isA<Stream<User?>>());
      });

       test('listenAuthStatus returns null on error', () {
        when(mockFirebaseAuth.authStateChanges()).thenThrow(Exception('stream error'));

        final result = authService.listenAuthStatus();

        expect(result, isNull);
      });

      test('signInAnon returns null on error', () async {
        when(mockFirebaseAuth.signInAnonymously()).thenThrow(Exception('anon error'));

        final result = await authService.signInAnon();

        expect(result, isNull);
      });

      test('signInWithCustomToken completes successfully', () async {
        when(mockFirebaseAuth.signInWithCustomToken('token'))
            .thenAnswer((_) async => mockUserCredential);

        await authService.signInWithCustomToken('token');

        verify(mockFirebaseAuth.signInWithCustomToken('token')).called(1);
      });

       test('signInWithCustomToken handles error', () async {
        when(mockFirebaseAuth.signInWithCustomToken('token'))
            .thenThrow(Exception('token error'));

        await authService.signInWithCustomToken('token');

        verify(mockFirebaseAuth.signInWithCustomToken('token')).called(1);
      });

      test('signInWithAuthCredential returns user on success', () async {
        final mockCredential = MockAuthCredential();
        when(mockFirebaseAuth.signInWithCredential(mockCredential))
            .thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);

        final result = await authService.signInWithAuthCredential(mockCredential);

        expect(result, mockUser);
      });

       test('signInWithAuthCredential returns null on error', () async {
        final mockCredential = MockAuthCredential();
        when(mockFirebaseAuth.signInWithCredential(mockCredential))
            .thenThrow(Exception('cred error'));

        final result = await authService.signInWithAuthCredential(mockCredential);

        expect(result, isNull);
      });

    });
  });
}