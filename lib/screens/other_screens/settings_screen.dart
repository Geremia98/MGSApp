import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:mgs_app2/screens/other_screens/personal_screen.dart';
import 'package:mgs_app2/screens/settings_screen.dart/FAQ_screen.dart';

//import 'package:mgs_app/utilities/auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';

import '../../wrapper.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'SettingsScreen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 60.0,
            vertical: 40.0,
          ),
          child: Column(
            children: <Widget>[
              userInfo(width),
              SizedBox(height: height * 0.06),
              CustomCard(
                icon: Icons.person,
                text: 'Info personali',
                onPressed: () =>
                    {Navigator.of(context).pushNamed(PersonalScreen.id)},
              ),
              SizedBox(height: height * 0.03),
              CustomCard(
                icon: Icons.question_mark,
                text: 'FAQ',
                onPressed: () => {
                  Navigator.of(context).pushNamed(FAQScreen.id),
                },
              ),
              SizedBox(height: height * 0.03),
              CustomCard(
                icon: Icons.bug_report,
                text: 'Report a bug',
                onPressed: () => {},
              ),
              SizedBox(height: height * 0.03),
              CustomCard(
                icon: Icons.logout,
                text: 'Logout',
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sicuro?'),
                      content: const Text(
                          'Se procedi tornerai alla schermata di LogIn. Convinto?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Nope'),
                        ),
                        TextButton(
                          onPressed: () {
                            //Auth(firebaseAuth: FirebaseAuth.instance).logout();
                            final FirebaseAuthService authService =
                                FirebaseAuthService();
                            authService.signOut(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Wrapper(),
                              ),
                            );
                          },
                          child: const Text('Yep'),
                        ),
                      ],
                    ),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final dynamic onPressed;

  const CustomCard({
    required this.icon,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: const ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(30, 50))),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Icon(icon),
            ),
            Expanded(
              flex: 8,
              child: Text(text, style: const TextStyle(fontSize: 16)),
            ),
            const Expanded(
              flex: 2,
              child: Icon(Icons.arrow_forward_rounded),
            )
          ],
        ));
  }
}

userInfo(width) {
  return Row(
    children: [
      Container(
        width: width * 0.25,
        height: width * 0.25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: UserModel.profilePic == null ||
                  UserModel.profilePic!.downloadUrl == null
              ? Image.asset(
                  'resources/profile_pic.jpeg',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  UserModel.profilePic!.downloadUrl!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UserModel.name,
              style: TextStyle(
                  fontFamily: 'Bebas', fontSize: width * 0.07, height: 1),
            ),
            Text(UserModel.email),
          ],
        ),
      )
    ],
  );
}
