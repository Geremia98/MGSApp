//boss si/no

//Se è boss mettere un positioned,
//come un pallino o una piccola label sulla foto profilo

import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * 5,
          vertical: appConfig.getHeight() * 7,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: appConfig.getHeight() * 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GoBackButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      appConfig: appConfig), 
                      Expanded(child: Container()),
                      
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: appConfig.getHeight() * 2),
              child: MyProfilePicture(
                appConfig: appConfig, 
                profileImage: 'assets/images/male.jpg', 
                borderRadius: personalePageProfilePicBorderRadius, 
                borderThickness: personaPageProfilePicBorderThickness, 
                dimension: personalPageProfilePicDimension)
            ),
            Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: buildMyTextFormField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            hintText: 'Nome',
            maxLength: 30,
            initialValue: UserModel.name,
            enabled: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: buildMyTextFormField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            hintText: 'Cognome',
            maxLength: 30,
            initialValue: UserModel.name,
          ),
        ),
            Divider(
              indent: appConfig.getWidth() * 15,
              endIndent: appConfig.getWidth() * 15,
              height: appConfig.getHeight() * 2,
              color: appConfig.getTheme().primaryColor ,
            ),
            Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: buildMyTextFormField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            hintText: 'Numero di telefono',
            maxLength: 30,
            initialValue: '3881113429',
          ),
        ),
            
            ButtonText(text: 'Modifica', onTap: () {}),
          ],
        ),
      ),
    );
  }
}