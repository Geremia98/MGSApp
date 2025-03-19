//import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:google_sign_in/google_sign_in.dart';

// class Auth {
//   final FirebaseAuth firebaseAuth;

//   static bool isGoogle = false;

//   Auth({required this.firebaseAuth});

//   Future<bool> login(email, password) async {
//     try {
//       await firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: password);
//       isGoogle = false;
//       return true;
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   Future<bool> googleLogin() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final googleUser = await googleSignIn.signIn();
//     if (googleUser == null) {
//       return false;
//     }
//     final googleAuth = await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
//     if (firebaseUser == null) {
//       return false;
//     }
//     isGoogle = true;
//     return true;
//   }

//   Future<bool> signIn(email, password) async {
//     try {
//       await firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       isGoogle = false;
//       return true;
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   String getusername() {
//     return firebaseAuth.currentUser.toString();
//   }

//   Future<void> logout() async {
//     await firebaseAuth.signOut();
//     if(isGoogle){
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       await googleSignIn.disconnect();
//       await googleSignIn.signOut();
//     }
//   }

//   bool isCurrentUserLoggedIn() {
//     if (firebaseAuth.currentUser == null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
