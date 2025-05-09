import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';

class MySegmentedButton<T> extends StatefulWidget {
  final Set<T> selected;
  final String title;
  final String leftString;
  final String rightString;
  final void Function(Set<T>) onValueChange;
  final T leftValue;
  final T rightValue;
  final bool isEnable;

  const MySegmentedButton(
      {required this.leftString,
      required this.rightString,
      required this.selected,
      required this.onValueChange,
      required this.title,
      required this.leftValue,
      required this.rightValue,
      required this.isEnable,
      super.key});

  @override
  State<MySegmentedButton<T>> createState() => _MySegmentedButtonState<T>();
}

class _MySegmentedButtonState<T> extends State<MySegmentedButton<T>> {
  late AppConfig _appConfig;
  late Set<T> _selected;
  late String _title;
  late String _leftString;
  late String _rightString;
  late T _leftValue;
  late T _rightValue;
  late void Function(Set<T>) _onValueChange;

  @override
  void initState() {
    _selected = widget.selected;
    _title = widget.title;
    _leftString = widget.leftString;
    _rightString = widget.rightString;
    _leftValue = widget.leftValue;
    _rightValue = widget.rightValue;
    _onValueChange = widget.onValueChange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _appConfig.getHeight()*0.7),
      child: Row(
        children: [
          Text(
            _title,
            style: TextStyle(
              color: _appConfig.getTheme().secondaryHeaderColor,
              fontWeight: fontWeightLabels,
              fontSize: fontSizeLables,
            ),
          ),
          SizedBox(width: 8),
          SegmentedButton<T>(
            segments: <ButtonSegment<T>>[
              ButtonSegment(value: _leftValue, label: Text(_leftString)),
              ButtonSegment(value: _rightValue, label: Text(_rightString))
            ],
            selected: _selected,
            onSelectionChanged: (newValue) {
                    if (widget.isEnable) {
                      setState(() {
                      _selected = newValue!;
                    });
                    if (_onValueChange != null) {
                      _onValueChange!(_selected);
                    }
                    }
                  },
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
          overlayColor: Colors.transparent,
              // colore di fondo “normale”
          backgroundColor: _appConfig.getTheme().scaffoldBackgroundColor,
          // colore di fondo quando selezionato
          selectedBackgroundColor: widget.isEnable ? _appConfig.getTheme().primaryColor :  _appConfig.getTheme().splashColor,
          
          // colore del testo “normale”
          foregroundColor: _appConfig.getTheme().primaryColor,
          // colore del testo quando selezionato
          selectedForegroundColor: _appConfig.getTheme().scaffoldBackgroundColor,
          // bordo e forma
          side: BorderSide(
            width: buttonsAndTextFieldsThickness,
            color: widget.isEnable ? _appConfig.getTheme().primaryColor : _appConfig.getTheme().disabledColor
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(toggleSwitchRadiusBorder)),
          // padding interno
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          // stile del testo (se vuoi applicarlo in modo uniforme)
          textStyle: const TextStyle(fontSize: fontSizeTextAndFormField, fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
