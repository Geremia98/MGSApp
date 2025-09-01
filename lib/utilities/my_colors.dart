import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color enabledCheckSquaredButton;
  final Color disabledCheckSquaredButton;
  final Color enabledUndoSquaredButton;
  final Color disabledUndoSquaredButton;

  const CustomColors({
    required this.enabledCheckSquaredButton,
    required this.disabledCheckSquaredButton,
    required this.disabledUndoSquaredButton,
    required this.enabledUndoSquaredButton,
  });

  @override
  CustomColors copyWith({Color? enabledCheckSquaredButton, Color? disabledCheckSquaredButton, Color? enabledUndoSquaredButton, Color? disabledUndoSquaredButton}) {
    return CustomColors(
      enabledCheckSquaredButton: enabledCheckSquaredButton ?? this.enabledCheckSquaredButton,
      disabledCheckSquaredButton: disabledCheckSquaredButton ?? this.disabledCheckSquaredButton,
      enabledUndoSquaredButton: enabledUndoSquaredButton ?? this.enabledUndoSquaredButton,
      disabledUndoSquaredButton: disabledUndoSquaredButton ?? this.disabledUndoSquaredButton,

    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      enabledCheckSquaredButton: Color.lerp(
          enabledCheckSquaredButton, other.enabledCheckSquaredButton, t)!,
      disabledCheckSquaredButton: Color.lerp(
          disabledCheckSquaredButton, other.disabledCheckSquaredButton, t)!,
      enabledUndoSquaredButton: Color.lerp(enabledUndoSquaredButton, other.enabledUndoSquaredButton, t)!,
      disabledUndoSquaredButton: Color.lerp(disabledUndoSquaredButton, other.disabledUndoSquaredButton, t)!,
    );
  }

  static const light = CustomColors(
    enabledCheckSquaredButton: Color.fromARGB(255, 45, 230, 141),
    disabledCheckSquaredButton: Color.fromARGB(255, 194, 237, 216),
    enabledUndoSquaredButton: Color.fromARGB(255, 213, 40, 28),
    disabledUndoSquaredButton: Color.fromARGB(255, 255, 191, 186),
  );

  static const dark = CustomColors(
    enabledCheckSquaredButton: Color.fromARGB(255, 133, 251, 194),
    disabledCheckSquaredButton: Color.fromARGB(255, 134, 165, 150),
    enabledUndoSquaredButton: Color.fromARGB(255, 252, 81, 69),
    disabledUndoSquaredButton: Color.fromARGB(255, 152, 66, 60),
  );
}
