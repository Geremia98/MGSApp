import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen3.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/image_upload.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';

import '../../widgets/font.dart';

class RegistrationScreen2 extends StatefulWidget {
  final RegistrationController controller;

  const RegistrationScreen2({
    required this.controller,
    super.key,
  });

  @override
  State<RegistrationScreen2> createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  late RegistrationController controller;
  bool _isDisabled = false;

  TextEditingController textFieldValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    controller.profilePic.toString().isNotEmpty
        ? _isDisabled = true
        : _isDisabled = false;
  }

  void calculateWetherEnablingTheButton() {
    controller.profilePic.toString().isNotEmpty
        ? setState(() {
            _isDisabled = false;
          })
        : setState(() {
            _isDisabled = true;
          });
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              right: appConfig.getWidth() * 8,
              left: appConfig.getWidth() * 8,
              top: appConfig.getHeight() * 0.7),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BackButtonAppBar(
                    iconData: Icons.arrow_back_rounded,
                    appConfig: appConfig,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: appConfig.getHeight() * 4,
                  ),
                  Center(
                    child: CircleAvatar(
                        radius: appConfig.getWidth() * 25,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 221, 109),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.asset(
                            'assets/images/sammy-camera.png',
                            height: 190,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      '... 1, 2, 3 ...\nCHEEESE!',
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      '(Sarà la tua foto profilo)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: appConfig.getWidth() * 4,
                        fontWeight: FontWeight.w500,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: ImageUploadCard(
                        width: appConfig.getWidth() * 50,
                        height: appConfig.getWidth() * 50,
                        imageType: ImageType.profilePicture,
                        initialImage: controller.profilePic,
                        onImagePicked: (value) {
                          controller.setProfilePicture(value);
                          calculateWetherEnablingTheButton();
                        }),
                  ),
                  //buildAddNewImageButton(context, width * 0.5, width * 0.5, width * 0.5),
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: MySquaredIconButton(
                    activeColor: appConfig.getTheme().primaryColor,
                    disabledColor: appConfig.getTheme().disabledColor,
                    icon: Icons.arrow_forward_rounded,
                    isEnable: !_isDisabled,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen3(
                                controller: controller,
                              )),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
