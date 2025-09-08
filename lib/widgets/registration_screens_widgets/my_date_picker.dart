import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/utils.dart';

import '../title.dart';

class MyDatePicker extends StatelessWidget {
  final DateTime? birthday;
  final String title;
  final bool isEnable;
  final double width;
  final double height;
  final void Function() onPressed;

  const MyDatePicker(
      {required this.title,
      this.birthday,
      required this.isEnable,
      required this.onPressed,
        this.width = 200,
      this.height = heightTextFormFieldWithoutError,
      super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: appConfig.getHeight() * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: appConfig.getWidth() * 79,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appConfig.getTheme().secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
                    fontSize: appConfig.getHeight() * 1.8,
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
          SizedBox(
            height: title.isNotEmpty ? 10 : 0,
          ),
          GestureDetector(
            onTap: () {
              if (!isEnable) {
                return;
              }
              onPressed();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              width: width,
              height: height,
              constraints: BoxConstraints(
                maxWidth: width,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: isEnable
                      ? appConfig.getTheme().primaryColor
                      : appConfig.getTheme().disabledColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  birthday == null
                      ? 'Data di nascita'
                      : formatDateFromDateTime(birthday),
                  style: textStyleSubtitle(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
