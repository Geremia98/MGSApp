import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/utils.dart';

class MyDatePicker extends StatelessWidget {
  final DateTime? birthday;
  final String title;
  final bool isEnable;
  final void Function() onPressed;

  const MyDatePicker(
      {required this.title, 
      this.birthday, 
      required this.isEnable,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: appConfig.getHeight()*0.7),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSizeOfLablesOfTextField,
              color: appConfig.getTheme().primaryColor,
              fontWeight: fontWeightOfLabelsOfTextField,
            ),
          ),
          SizedBox(width: 8),
          Text(
            formatDateFromDateTime(birthday),
            style: TextStyle(
              fontSize: fontSizeOfTextAndFormField,
              color: appConfig.getTheme().primaryColor,
            ),
          ),
          SizedBox(width: 18),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: isEnable ? appConfig.getTheme().primaryColor : appConfig.getTheme().splashColor,
                  borderRadius: BorderRadius.circular(
                      appConfig.getWidth() * 5), // Bordi arrotondati
                  border: Border.all(
                    width: 1,
                    color: isEnable ? appConfig.getTheme().primaryColor : appConfig.getTheme().splashColor,
                  )),
              child: Icon(
                Icons.mode_edit_rounded,
                // Icona simile a quella mostrata
                size: fontSizeOfTextAndFormField,
                color:
                    appConfig.getTheme().scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
