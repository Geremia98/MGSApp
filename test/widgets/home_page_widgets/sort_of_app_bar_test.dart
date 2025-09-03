import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/home_page_widgets/sort_of_app_bar.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import '../../mocks.mocks.dart';
import '../../test_helpers.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    UserModel.uid = 'someuid';
    UserModel.name = 'name';
    UserModel.surname = 'surname';
    UserModel.gender = UserGender.male;
    UserModel.birth = DateTime.now();
    UserModel.country = 'IT';
    UserModel.ispettoria = 'Triveneto';
    UserModel.group = 'Sesto';
    UserModel.bossCode = 'bossCode';
  });

  testWidgets('SortOfAppBar displays icon and opens drawer', (WidgetTester tester) async {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final mockStorageService = MockFirebaseStorageService();

    when(mockStorageService.getUserProfileImage(any)).thenAnswer((_) async => null);

    await tester.pumpWidget(
      MaterialApp(
        theme: getLightTheme(),
        home: Scaffold(
          key: scaffoldKey,
          drawer: const Drawer(),
          body: Builder(
            builder: (context) {
              return SizedBox(
                width: 500,
                child: SortOfAppBar(
                  appConfig: AppConfig(context),
                  iconData: Icons.menu,
                  globalKey: scaffoldKey,
                  storageService: mockStorageService,
                ),
              );
            }
          ),
        ),
      ),
    );

    // Verify that our app bar has the correct icon.
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Tap the menu icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    // Verify that the drawer is open.
    expect(scaffoldKey.currentState!.isDrawerOpen, isTrue);
  });

  testWidgets('SortOfAppBar navigates to PersonalScreen', (WidgetTester tester) async {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final mockStorageService = MockFirebaseStorageService();

    when(mockStorageService.getUserProfileImage(any)).thenAnswer((_) async => null);

    await tester.pumpWidget(
      MaterialApp(
        theme: getLightTheme(),
        home: Scaffold(
          key: scaffoldKey,
          drawer: const Drawer(),
          body: Builder(
            builder: (context) {
              return SizedBox(
                width: 500,
                child: SortOfAppBar(
                  appConfig: AppConfig(context),
                  iconData: Icons.menu,
                  globalKey: scaffoldKey,
                  storageService: mockStorageService,
                ),
              );
            }
          ),
        ),
      ),
    );

    // Tap the profile picture and trigger a frame.
    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector && widget.child is MyProfilePicture));
    await tester.pumpAndSettle();

    // Verify that we have navigated to the PersonalScreen.
    expect(find.byType(PersonalScreen), findsOneWidget);
  });
}

