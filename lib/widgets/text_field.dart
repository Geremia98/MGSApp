import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgs_app2/widgets/font.dart';

import '../utilities/app_config.dart';

Widget buildTextField(
  AppConfig appConfig, {
  String labelText = '',
  TextInputType textInputType = TextInputType.text,
  IconData? icon,
  String hintText = '',
  TextEditingController? controller,
  String? Function(String?)? validator,
  bool obscureText = false,
  Function(String?)? onSaved,
  Function(String?)? onChanged,
  bool autofocus = false,
  int maxLines = 1,
  int minLines = 1,
  String initialValue = '',
  Color? labelColor,
  Color? iconColor,
  Color? textColor,
  Widget? suffixWidget,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool showError = true,
  bool enabled = true,
  int maxLength = 100,
  List<TextInputFormatter>? inputFormatters,
}) {
  labelColor ??= Colors.grey;
  iconColor ??= Colors.grey;
  textColor ??= appConfig.getTheme().secondaryHeaderColor;

  return Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      if (labelText.isNotEmpty)
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: appConfig.getWidth() * 79,
            child: Text(
              labelText,
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
        height: labelText.isNotEmpty ? 10 : 0,
      ),
      SizedBox(
        height: maxLines == 1 ? appConfig.getHeight() * 8 : appConfig.getHeight() * 15,
        child: TextFormField(
          keyboardType: textInputType,
          validator: validator,
          enabled: enabled,
          obscureText: obscureText,
          style: maxLines != 1
              ? textStyleTextField(appConfig.getContext()).copyWith(
                  height: 1.4,
                )
              : textStyleTextField(appConfig.getContext()),
          controller: controller,
          onSaved: onSaved,
          autofocus: autofocus,
          onChanged: onChanged,
          initialValue: controller != null ? null : initialValue,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          cursorColor: appConfig.getTheme().primaryColor,
          decoration: InputDecoration(
            fillColor: appConfig.getTheme().scaffoldBackgroundColor,
            //labelText: hintText,
            counterText: "",
            isDense: true,
            hintText: hintText,
            suffix: suffixWidget,
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            //fillColor: appConfig.getTheme().cardColor,
            filled: true,
            errorStyle: showError
                ? textStyleFormError(appConfig.getContext())
                : const TextStyle(height: 0, color: Colors.transparent),
            errorMaxLines: 3,
            labelStyle: textStyleHint(appConfig.getContext()),
            hintStyle: textStyleHint(appConfig.getContext()),
            contentPadding: EdgeInsets.only(
              top: appConfig.getHeight() * 3,
              bottom: appConfig.getHeight() * 0,
              left: 15,
            ),
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: iconColor,
                  ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appConfig.getTheme().primaryColor,
                width: appConfig.getWidth()*0.1
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appConfig.getTheme().primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  );
}

TextStyle textStyleFormError(BuildContext context) => const TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.w500,
  fontSize: fontSizeMedium,
);

TextStyle textStyleHint(BuildContext context) => const TextStyle(
  color: Colors.grey,
  fontSize: fontSizeBig,
  fontWeight: FontWeight.w500,
  overflow: TextOverflow.ellipsis,
);


TextStyle textStyleTextField(BuildContext context) => TextStyle(
  color: AppConfig(context).getTheme().secondaryHeaderColor,
  fontWeight: FontWeight.w500,
  fontSize: fontSizeMedium,
);


class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;

  const PrimaryTextField({
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildTextField(
      AppConfig(context),
      controller: controller,
      labelText: labelText,
      maxLines: maxLines,
    );
  }
}