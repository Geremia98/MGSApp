import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../utilities/constants_dimensions.dart';

class MyCustomSegmentedButton<T> extends StatefulWidget {
  final T leftValue;
  final T rightValue;
  final String leftText;
  final String rightText;
  final T selected;
  final void Function(T) onValueChange;
  final bool isEnabled;
  final double height;
  final double width;
  final String title;
  final double borderRadius;

  const MyCustomSegmentedButton({
    super.key,
    required this.leftValue,
    required this.rightValue,
    required this.leftText,
    required this.rightText,
    required this.selected,
    required this.onValueChange,
    this.isEnabled = true,
    this.title = '',
    this.height = heightTextFormFieldWithoutError,
    this.width = 200,
    this.borderRadius = 10,
  });

  @override
  State<MyCustomSegmentedButton<T>> createState() =>
      _MyCustomSegmentedButtonState<T>();
}
class _MyCustomSegmentedButtonState<T>
    extends State<MyCustomSegmentedButton<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: appConfig.getWidth() * 79,
              child: Text(
                widget.title,
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
          height: widget.title.isNotEmpty ? 10 : 0,
        ),

        SizedBox(
          height: widget.height,
          width: widget.width,
          child: Row(
            children: [
              // LEFT
              Expanded(
                child: _buildSegment(
                  value: widget.leftValue,
                  label: widget.leftText,
                  isFirst: true,
                  isSelected: _selected == widget.leftValue,
                  theme: appConfig.getTheme(),
                ),
              ),
              // RIGHT
              Expanded(
                child: _buildSegment(
                  value: widget.rightValue,
                  label: widget.rightText,
                  isFirst: false,
                  isSelected: _selected == widget.rightValue,
                  theme: appConfig.getTheme(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegment({
    required T value,
    required String label,
    required bool isFirst,
    required bool isSelected,
    required ThemeData theme,
  }) {
    final borderSide = BorderSide(
      width: 0.5,
      color: widget.isEnabled
          ? theme.secondaryHeaderColor
          : theme.disabledColor,
    );

    // bordo centrale metà spessore
    final centerBorderSide = borderSide.copyWith(width: borderSide.width / 2);

    return Material(
      color: isSelected
          ? (widget.isEnabled ? theme.secondaryHeaderColor : Colors.grey.shade500)
          : theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? Radius.circular(widget.borderRadius) : Radius.zero,
          right: !isFirst ? Radius.circular(widget.borderRadius) : Radius.zero,
        ),
        side: BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? Radius.circular(widget.borderRadius) : Radius.zero,
          right: !isFirst ? Radius.circular(widget.borderRadius) : Radius.zero,
        ),
        onTap: widget.isEnabled
            ? () {
          setState(() {
            _selected = value;
          });
          widget.onValueChange(value);
        }
            : null,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? Radius.circular(widget.borderRadius) : Radius
                  .zero,
              right: !isFirst ? Radius.circular(widget.borderRadius) : Radius
                  .zero,
            ),
            border: Border(
              left: isFirst ? borderSide : centerBorderSide,
              right: !isFirst ? borderSide : centerBorderSide,
              top: borderSide,
              bottom: borderSide,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? theme.scaffoldBackgroundColor
                  : theme.secondaryHeaderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

