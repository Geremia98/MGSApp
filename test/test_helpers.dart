import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirebaseCore extends Mock with MockPlatformInterfaceMixin implements FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp();
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseApp();
  }
}

class MockFirebaseApp extends Mock with MockPlatformInterfaceMixin implements FirebaseAppPlatform {
  @override
  FirebaseOptions get options => const FirebaseOptions(
        apiKey: '123',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
        storageBucket: '123',
      );

  @override
  String get name => 'test';
}


void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.delegatePackingProperty = MockFirebaseCore();
}

MockFirebaseAuth getMockFirebaseAuth() {
  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  return MockFirebaseAuth(mockUser: user);
}
