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
  bool centerText = false, // <-- aggiunto
}) {
  labelColor ??= Colors.grey;
  iconColor ??= Colors.grey;
  textColor ??= appConfig.getTheme().secondaryHeaderColor;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: appConfig.getHeight() * 0),
    child: Container(
      width: appConfig.getWidth() * maxLength,
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
              : SizedBox(width: appConfig.getWidth() * 3),
          Expanded(
            child: Container(
              width: appConfig.getWidth() * 10,
              alignment: centerText ? Alignment.center : Alignment.centerLeft,
              // <-- allineamento
              height: helperText
                  ? heightTextFormFieldWithError
                  : heightTextFormFieldWithoutError,
              child: TextFormField(
                keyboardType: textInputType,
                validator: validator,
                enabled: enabled,
                obscureText: obscureText,
                style: textStyleTextField(appConfig.getContext()),
                controller: controller,
                onSaved: onSaved,
                autofocus: autofocus,
                onChanged: onChanged,
                initialValue: controller != null ? null : initialValue,
                maxLines: maxLines,
                maxLength: maxLength,
                textCapitalization: textCapitalization,
                cursorColor: appConfig.getTheme().primaryColor,
                textAlign: centerText ? TextAlign.center : TextAlign.start,
                // <-- centrato
                decoration: InputDecoration(
                  fillColor: appConfig.getTheme().scaffoldBackgroundColor,
                  counterText: "",
                  helperText: helperText ? '' : null,
                  isDense: true,
                  hintText: hintText,
                  suffix: suffixWidget,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  errorStyle: showError
                      ? textStyleFormError(appConfig.getContext())
                      : const TextStyle(height: 0, color: Colors.transparent),
                  labelStyle: textStyleHint(appConfig.getContext()),
                  hintStyle: textStyleHint(appConfig.getContext()),
                  contentPadding: EdgeInsets.only(
                    top: 20,
                    bottom: 0,
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
                        width:
                            thicknessOfBordersEnabledButtonsAndTextFormField),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: appConfig.getTheme().disabledColor,
                        width:
                            thicknessOfBordersEnabledButtonsAndTextFormField),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: appConfig.getTheme().primaryColor,
                        width: thicknessOfBordersWhenOnFocus),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: appConfig.getTheme().indicatorColor,
                        width:
                            thicknessOfBordersEnabledButtonsAndTextFormField),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: appConfig.getTheme().primaryColor,
                        width: thicknessOfBordersWhenOnFocus),
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

class CodeInputField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final bool isEnabled;
  final String initialValue;
  final bool hasTitle;

  const CodeInputField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.hasTitle = true,
    this.initialValue = '',
    this.isEnabled = true,
  });

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (i) {
        String char = '';
        if (i < widget.initialValue.length) {
          char = widget.initialValue[i];
        }
        return TextEditingController(text: char);
      },
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // prende solo l’ultimo carattere
      value = value.substring(value.length - 1);
      _controllers[index].text = value;
      // sposta il cursore alla fine
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
    }

    // passa al prossimo campo
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // controlla se tutti i campi hanno un valore
    String code = _controllers.map((c) => c.text).join();
    if (!_controllers.any((c) => c.text.isEmpty)) {
      widget.onCompleted?.call(code);
    }
  }

  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      children: [
        if (widget.hasTitle)
          SizedBox(
            width: ((40 * widget.length) + (8 * widget.length)).toDouble(),
            child: Text(
              'Codice Boss',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: appConfig.getTheme().secondaryHeaderColor,
                fontWeight: FontWeight.w500,
                fontSize: appConfig.getHeight() * 1.8,
              ),
            ),
          ),
        if (widget.hasTitle)
          SizedBox(
            height: 10,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              width: 40, // più stretta
              height: heightTextFormFieldWithoutError,
              margin:
                  EdgeInsets.symmetric(horizontal: widget.isEnabled ? 4 : 0),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => _onKey(event, index),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.isEnabled,
                  textAlign: TextAlign.center,
                  style: textStyleTextField(context)
                      .copyWith(fontSize: fontSizeBig),
                  keyboardType: TextInputType.text,
                  cursorColor: appConfig.getTheme().secondaryHeaderColor,
                  maxLength: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    counterText: "",
                    filled: true,
                    fillColor: appConfig.getTheme().scaffoldBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: !widget.isEnabled
                              ? Colors.transparent
                              : appConfig.getTheme().primaryColor,
                          width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: !widget.isEnabled
                              ? Colors.transparent
                              : appConfig.getTheme().primaryColor,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (v) => _onChanged(v, index),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

TextStyle textStyleFormError(BuildContext context) => const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w500,
      fontSize: fontSizeMedium,
    );

TextStyle textStyleHint(BuildContext context) => const TextStyle(
      color: Colors.grey,
      fontSize: fontSizeMedium,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    );

TextStyle textStyleTextField(BuildContext context) => TextStyle(
      color: AppConfig(context).getTheme().secondaryHeaderColor,
      fontWeight: FontWeight.w500,
      fontSize: fontSizeMedium,
    );
