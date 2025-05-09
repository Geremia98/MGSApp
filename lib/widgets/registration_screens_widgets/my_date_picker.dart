import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/utils.dart';

class MyDatePicker extends StatefulWidget {
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
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late AppConfig _appConfig;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);
    return Row(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: fontSizeLables,
            color: _appConfig.getTheme().primaryColor,
            fontWeight: fontWeightLabels,
          ),
        ),
        SizedBox(width: 8),
        Text(
          formatDateFromDateTime(widget.birthday),
          style: TextStyle(
            fontSize: fontSizeTextAndFormField,
            color: _appConfig.getTheme().primaryColor,
          ),
        ),
        SizedBox(width: 18),
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: widget.isEnable ? _appConfig.getTheme().primaryColor : _appConfig.getTheme().splashColor,
                borderRadius: BorderRadius.circular(
                    _appConfig.getWidth() * 5), // Bordi arrotondati
                border: Border.all(
                  width: 1,
                  color: widget.isEnable ? _appConfig.getTheme().primaryColor : _appConfig.getTheme().splashColor,
                )),
            child: Icon(
              Icons.mode_edit_rounded,
              // Icona simile a quella mostrata
              size: fontSizeTextAndFormField,
              color:
                  _appConfig.getTheme().scaffoldBackgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
