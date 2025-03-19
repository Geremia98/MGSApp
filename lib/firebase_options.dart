import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB2IhdJhvfACFKfHX-NoLOWm3l0NY3UwTY',
    appId: '1:1021357601300:web:4d064685a6581288bbad01',
    messagingSenderId: '1021357601300',
    projectId: 'supermercatofirebase',
    authDomain: 'supermercatofirebase.firebaseapp.com',
    databaseURL: 'https://supermercatofirebase.firebaseio.com',
    storageBucket: 'supermercatofirebase.appspot.com',
    measurementId: 'G-FZRFZ9PH30',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCl1xe6kgdPF4YVWS8Eau9xsF9adTaLQ68',
    appId: '1:1021357601300:android:48528cbb821edec1bbad01',
    messagingSenderId: '1021357601300',
    projectId: 'supermercatofirebase',
    databaseURL: 'https://supermercatofirebase.firebaseio.com',
    storageBucket: 'supermercatofirebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfT8i193u9gKkDpo9Gm-71crxftxy5suw',
    appId: '1:1021357601300:ios:4eb5b35af188c766bbad01',
    messagingSenderId: '1021357601300',
    projectId: 'supermercatofirebase',
    databaseURL: 'https://supermercatofirebase.firebaseio.com',
    storageBucket: 'supermercatofirebase.appspot.com',
    androidClientId: '1021357601300-8thlpkolp652gm6kdlobuavb6ii2rfc4.apps.googleusercontent.com',
    iosClientId: '1021357601300-io4rc8qm6ejkrgu5gkf6dpe1nj70h3r3.apps.googleusercontent.com',
    iosBundleId: 'com.example.mgsApp2',
  );
}