import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exceptions_translator.dart';

class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  FirebaseAuth getFirebaseInstance() => _auth;

  User? getCurrentUser() => _auth.currentUser;

  Future<bool> _reloadUser() async {
    if (!isUserLogged()) {
      return false;
    }

    try {
      await getCurrentUser()!.reload();
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('Error while reloading user: $error');
      }
      return false;
    }
  }

  bool isUserEmailVerified() {
    if (!isUserLogged()) {
      return false;
    }

    return getCurrentUser()!.emailVerified;
  }

  Future<void> sendVerificationEmail() async {
    if (!isUserLogged()) {
      return;
    }

    return await getCurrentUser()!.sendEmailVerification();
  }

  Stream<User?>? listenAuthStatus() {
    try {
      return _auth
          .authStateChanges()
          .map((user) => isUserLogged() ? user : null);
    } catch (error) {
      if (kDebugMode) {
        print('error while listening auth status: $error');
      }
      return null;
    }
  }

  /// Check if user is already logged.
  /// In true case try to reload login and check value.
  ///
  /// returns true if user is logged, false otherwise
  bool isUserLogged() => getCurrentUser() != null;

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      //return _userFromFirebaseUser(user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    if (!isUserLogged()) {
      return;
    }

    await _auth.signOut();
    await _reloadUser();


  }


  Future<void> signInWithCustomToken(String customToken) async {
    try {
      await _auth.signInWithCustomToken(customToken);
      print('User signed in successfully with custom token');
    } catch (error) {
      print('Error signing in with custom token: $error');
      // Handle error as needed
    }
  }

  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    final FirebaseExceptionsTranslator _translator = FirebaseExceptionsTranslator();

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (error) {
      final message = _translator.getAuthMessage(error);
      if (kDebugMode) {
        print('FirebaseAuthException during sign in: ${error.code}');
      }
      return message;
    } on PlatformException catch (error) {
      final message = _translator.getDatabaseMessage(error);
      if (kDebugMode) {
        print('PlatformException during sign in: ${error.code}');
      }
      return message;
    } catch (error) {
      if (kDebugMode) {
        print('Unexpected error during sign in: $error');
      }
      return "Errore sconosciuto! Contatta l'assistenza.";
    }
  }

  Future<User?> signInWithAuthCredential(AuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (error) {
      if (kDebugMode) {
        print(
            'error while checking user credential in two factor auth: $error');
      }
      return null;
    }
  }

  // register with email and password
  Future<dynamic> registerWithEmailAndPassword(String email, String password) async {
    try {

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (error) {
      if (kDebugMode) {
        print('Error while registering: $error');
      }
      return translateFirebaseAuthError(error.toString());
    }
  }

  String translateFirebaseAuthError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email già registrata';
    } else if (error.contains('invalid-email')) {
      return 'Email non valida';
    } else if (error.contains('weak-password')) {
      return 'Password troppo debole';
    } else if (error.contains('operation-not-allowed')) {
      return 'Registrazione non consentita';
    } else if (error.contains('too-many-requests')) {
      return 'Troppe richieste, riprova più tardi';
    } else {
      return 'Errore durante la registrazione';
    }
  }

  Future<dynamic> sendPasswordResetEmail(String email) async {
      if (email.isEmpty) {
        return null;
      }

      if (_auth.currentUser != null) {
        return null;
      }

      try {
        await _auth.sendPasswordResetEmail(email: email);
        return true;
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print('FirebaseAuthException: ${e.code} - ${e.message}');
        }
        return e; // oppure: throw e; se vuoi propagarlo
      } catch (e) {
        if (kDebugMode) {
          print('Unknown error: $e');
        }
        return FirebaseAuthException(
          code: 'unknown',
          message: 'An unknown error occurred.',
        );
      }
  }

  Future resetPassword(String newPass) async {
    const String message = 'Password aggiornata';
    if (!isUserLogged()) {
      return;
    }
    final User? user = getCurrentUser();
    final FirebaseExceptionsTranslator exceptionMessage = FirebaseExceptionsTranslator();

    if (user == null) {
      return;
    }

    try {
      await user.updatePassword(newPass);
    } on FirebaseAuthException catch (error) {
      return exceptionMessage.getAuthMessage(error);
    }

    return message;
  }

  Future<String?> resetEmail(String newEmail) async {

    if (!isUserLogged()) {
      return null;
    }
    final String message = 'Ti abbiamo mandato un link di conferma sulla email $newEmail';
    final User? user = getCurrentUser();

    if (user == null) {
      return null;
    }

    final FirebaseExceptionsTranslator exceptionMessage = FirebaseExceptionsTranslator();

    try {
      await user.verifyBeforeUpdateEmail(newEmail);

      sendVerificationEmail();

    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print(
            "error while updating email: code: ${error.code} | message: $exceptionMessage.getAuthMessage(error)");
      }
      return exceptionMessage.getAuthMessage(error);
    }

    return message;
  }

}
