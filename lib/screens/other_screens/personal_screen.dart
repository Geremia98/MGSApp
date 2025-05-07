//boss si/no

//Se è boss mettere un positioned,
//come un pallino o una piccola label sulla foto profilo

import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/text_field.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  PersonalScreenState createState() => PersonalScreenState();
}

class PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GoBackButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      appConfig: appConfig)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Center(
                child: Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/male.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(width * 0.5),
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: width * 0.001,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Geremia Moretti',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Divider(
              indent: width * 0.06,
              endIndent: width * 0.06,
              height: height * 0.02,
            ),
            Text(
              'Nato il 09-12-1998',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Ispettoria: Triveneto',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Gruppo: Sesto',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Numero di telefono:\n+393881113429',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            ButtonText(text: 'Modifica', onTap: () {}),
            buildTextField(appConfig,
                textCapitalization: TextCapitalization.sentences,
                hintText: UserModel.name,
                maxLines: 1,
                enabled: false),
          ],
        ),
      ),
    );
  }
}
