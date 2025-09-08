import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/font.dart';

class MyBigAsyncButton extends StatefulWidget {
  const MyBigAsyncButton({
    super.key,
    required this.appConfig,
    required this.onPressedAsync,
    this.buttonText = 'Conferma',
  });

  final AppConfig appConfig;
  final Future<void> Function() onPressedAsync;
  final String buttonText;

  @override
  State<MyBigAsyncButton> createState() => _MyBigAsyncButtonState();
}

class _MyBigAsyncButtonState extends State<MyBigAsyncButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    setState(() => _isLoading = true);
    try {
      await widget.onPressedAsync();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          widget.appConfig.getTheme().primaryColor,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: _isLoading ? null : _handlePressed,
      child: SizedBox(
        height: 45,
        child: _isLoading
            ? Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        widget.appConfig.getTheme().scaffoldBackgroundColor,
                  ),
                ),
              )
            : Center(
                child: Text(
                  widget.buttonText,
                  style: textStyleButton(context)
                ),
              ),
      ),
    );
  }
}
