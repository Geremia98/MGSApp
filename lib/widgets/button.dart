
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/app_config.dart';
import 'font.dart';

class ButtonIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final bool isLoading;
  final bool isEnabled;
  final Color? color;
  final double fixedWidth;

  const ButtonIcon({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.fixedWidth = -1,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return GestureDetector(
      onTap: isLoading || !isEnabled ? null : onTap,
      child: Container(
        height: appConfig.getHeight() * 5,
        width: fixedWidth != -1 ? fixedWidth : null,
        padding: EdgeInsets.symmetric(
          horizontal: fixedWidth == -1 ? appConfig.getWidth() * 5 : 0,
        ),
        decoration: isEnabled
            ? buttonIconDecoration(context)
                .copyWith(color: color ?? buttonIconDecoration(context).color)
            : buttonTextDisabledDecoration(context),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  icon,
                  color: appConfig.getTheme().secondaryHeaderColor,
                  size: 16,
                ),
              ),
              isLoading
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox(),
              isLoading
                  ? CupertinoActivityIndicator(
                      color:
                          AppConfig(context).getTheme().scaffoldBackgroundColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final bool isLoading;
  final bool isEnabled;
  final double fixedWidth;
  final Color? color;
  final Color? textColor;

  const ButtonText({
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.fixedWidth = -1,
    this.textColor,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return GestureDetector(
      onTap: isLoading || !isEnabled ? null : onTap,
      child: Container(
        height: appConfig.isTablet() ? 60 : 40,
        width: fixedWidth != -1 ? fixedWidth : null,
        padding: EdgeInsets.symmetric(
          horizontal: fixedWidth == -1 ? appConfig.getWidth() * 15 : 0,
        ),
        decoration: isEnabled
            ? buttonTextDecoration(context).copyWith(color: color ?? buttonTextDecoration(context).color )
            : buttonTextDisabledDecoration(context),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  text,
                  style: textStyleButton(context).copyWith(color: textColor ?? textStyleButton(context).color),
                ),
              ),
              isLoading
                  ? SizedBox(
                      width: 10,
                    )
                  : SizedBox(),
              isLoading
                  ? CupertinoActivityIndicator(
                      color:
                          AppConfig(context).getTheme().scaffoldBackgroundColor,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonTextAsTextField extends StatelessWidget {
  final String? value;
  final String? hint;
  final void Function() onTap;
  final bool isLoading;
  final bool hasError;
  final String error;
  final BoxDecoration? decoration;

  const ButtonTextAsTextField({
    this.value,
    this.hint,
    required this.onTap,
    this.isLoading = false,
    this.hasError = false,
    this.error = '',
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            height: 48,
            decoration: decoration == null
                ? buttonAsTextFieldDecoration(context, hasError)
                : decoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  value ?? hint ?? '',
                  style: value == null
                      ? textStyleHint(appConfig.getContext())
                      : textStyleTextField((context)),
                ),
                isLoading
                    ? SizedBox(
                        width: 10,
                      )
                    : SizedBox(),
                isLoading
                    ? CupertinoActivityIndicator(
                        color: AppConfig(context)
                            .getTheme()
                            .scaffoldBackgroundColor,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hasError ? error : '',
            style: textStyleFormError(context),
          ),
        )
      ],
    );
  }

}



BoxDecoration buttonTextDecoration(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return BoxDecoration(
    color: appConfig.getTheme().primaryColor,
    //boxShadow: boxShadowButton,
    borderRadius: BorderRadius.circular(10),
  );
}

BoxDecoration buttonIconDecoration(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return BoxDecoration(
    color: Colors.grey.shade400.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
  );
}

BoxDecoration buttonTextDisabledDecoration(BuildContext context) {
  return BoxDecoration(
    color: Colors.grey.withOpacity(0.2),
    //boxShadow: boxShadowButton,
    borderRadius: BorderRadius.circular(10),
  );
}


TextStyle textStyleButton(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeButton,),
    fontWeight: FontWeight.bold,
    color: AppConfig(context)
        .getTheme()
        .scaffoldBackgroundColor,
  );
}

TextStyle textStyleTitle(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeHuge,),
    fontWeight: FontWeight.w500,
    color: AppConfig(context)
        .getTheme()
        .primaryColor,
  );
}

TextStyle textStyleSubtitle(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeMedium,),
    fontWeight: FontWeight.w500,
    color: AppConfig(context)
        .getTheme()
        .primaryColor,
  );
}

TextStyle textStyleItemMenu(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeMedium,),
    fontWeight: FontWeight.w300,
    color: AppConfig(context)
        .getTheme()
        .primaryColor,
  );
}

TextStyle textStyleVediTutti(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeMedium,),
    fontWeight: FontWeight.w400,
    color: AppConfig(context)
        .getTheme()
        .primaryColor,
  );
}

TextStyle textStyleHomePersonalRow(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, fontSizeHuge,),
    fontWeight: FontWeight.w500,
    color: AppConfig(context)
        .getTheme()
        .primaryColor,
  );
}

TextStyle textStyleEventCardTitle(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, AppConfig(context).isTablet() ? fontSizeBig : fontSizeMedium),
    fontWeight: FontWeight.w500,
    color: AppConfig(context)
        .getTheme()
        .secondaryHeaderColor,
  );
}

TextStyle textStyleEventCardSubtitle(BuildContext context) {
  return TextStyle(
    fontSize: responsiveFontSize(context, AppConfig(context).isTablet() ? fontSizeBig - 1 : fontSizeMedium - 1),
    fontWeight: FontWeight.w300,
    color: AppConfig(context)
        .getTheme()
        .secondaryHeaderColor,
  );
}

BoxDecoration buttonAsTextFieldDecoration(BuildContext context, bool hasError) {
  final AppConfig appConfig = AppConfig(context);
  return BoxDecoration(
    color: appConfig.getTheme().scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
        color: hasError
            ? Colors.red.withOpacity(0.7)
            : Colors.grey.withOpacity(0.5)),
  );
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const PrimaryButton({
    required this.onPressed,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonText(
      onTap: onPressed ?? () {},
      text: label,
      isEnabled: onPressed != null,
    );
  }
}

TextStyle textStyleFormError(BuildContext context) => TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.w500,
  fontSize: responsiveFontSize(context, fontSizeMedium,),
);

TextStyle textStyleHint(BuildContext context) => TextStyle(
  color: Colors.grey,
  fontSize: responsiveFontSize(context, fontSizeBig,),
  fontWeight: FontWeight.w500,
  overflow: TextOverflow.ellipsis,
);


TextStyle textStyleTextField(BuildContext context) => TextStyle(
  color: AppConfig(context).getTheme().secondaryHeaderColor,
  fontWeight: FontWeight.w500,
  fontSize: responsiveFontSize(context, fontSizeMedium,),
);
