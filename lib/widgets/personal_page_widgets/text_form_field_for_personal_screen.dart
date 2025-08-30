import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/font.dart';

Widget buildMyTextFormField(
  AppConfig appConfig, {
    double textPadding = 15,
  String labelText = '',
  TextInputType textInputType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  IconData? icon,
  String hintText = '',
  TextEditingController? controller,
  String? Function(String?)? validator,
  bool obscureText = false,
  Function(String?)? onSaved,
  Function(String?)? onChanged,
  bool autofocus = false,
  int maxLines = 1,
  String initialValue = '',
  Color? labelColor,
  Color? iconColor,
  Color? textColor,
  Widget? suffixWidget,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool showError = true,
  bool enabled = true,
  int maxLength = 100,
  bool helperText = false,
}) {
  labelColor ??= Colors.grey;
  iconColor ??= Colors.grey;
  textColor ??= appConfig.getTheme().secondaryHeaderColor;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: appConfig.getHeight()*0.7),
    child: Container(
        width: appConfig.getWidth()*maxLength,
        child: Row(
          children: <Widget>[
                Text(
                  labelText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appConfig.getTheme().secondaryHeaderColor,
                    fontWeight: fontWeightOfLabelsOfTextField,
                    fontSize: fontSizeOfLablesOfTextField,
                  ),
                ),
            labelText == '' 
            ? SizedBox()
            : SizedBox(
              width: appConfig.getWidth()*3
            ),
            Expanded(
              child: Container(
                width: appConfig.getWidth()*10,
                alignment: Alignment.center,
                height: helperText ? heightTextFormFieldWithError : heightTextFormFieldWithoutError,
                child: TextFormField(
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            validator: validator,
            enabled: enabled,
            obscureText: obscureText,
            style: TextStyle(
              letterSpacing: 0.8,
              fontSize: fontSizeOfTextAndFormField, 
              fontWeight: FontWeight.w500,
              color: appConfig.getTheme().primaryColor
            ),
            controller: controller,
            onSaved: onSaved,
            autofocus: autofocus,
            onChanged: onChanged,
            initialValue: controller != null ? null : initialValue,
            maxLines: maxLines,
            maxLength: maxLength,
            textCapitalization: textCapitalization,
            cursorColor: appConfig.getTheme().primaryColor,
            decoration: InputDecoration(
              fillColor: appConfig.getTheme().scaffoldBackgroundColor,
              //labelText: hintText,
              counterText: "",
              helperText: helperText ? '' : null,
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
              labelStyle: textStyleHint(appConfig.getContext()),
              hintStyle: textStyleHint(appConfig.getContext()),
              contentPadding: EdgeInsets.only(
                top: appConfig.getHeight() * 2,
                bottom: appConfig.getHeight() * 0,
                left: textPadding,
                right: textPadding,
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
                  width: thicknessOfBordersEnabledButtonsAndTextFormField
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appConfig.getTheme().disabledColor,
                  width: thicknessOfBordersEnabledButtonsAndTextFormField
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appConfig.getTheme().primaryColor,
                  width: thicknessOfBordersWhenOnFocus
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appConfig.getTheme().indicatorColor,
                  width: thicknessOfBordersEnabledButtonsAndTextFormField
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appConfig.getTheme().primaryColor,
                  width: thicknessOfBordersWhenOnFocus
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
              ),
            ),
          ],
        ),
      ),
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