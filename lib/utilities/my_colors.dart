import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color enabledCheckSquaredButton;
  final Color disabledCheckSquaredButton;

  const CustomColors({
    required this.enabledCheckSquaredButton,
    required this.disabledCheckSquaredButton,
  });

  @override
  CustomColors copyWith({Color? coloreMio1, Color? coloreMio2}) {
    return CustomColors(
      enabledCheckSquaredButton: coloreMio1 ?? this.enabledCheckSquaredButton,
      disabledCheckSquaredButton: coloreMio2 ?? this.disabledCheckSquaredButton,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      enabledCheckSquaredButton: Color.lerp(enabledCheckSquaredButton, other.enabledCheckSquaredButton, t)!,
      disabledCheckSquaredButton: Color.lerp(disabledCheckSquaredButton, other.disabledCheckSquaredButton, t)!,
    );
  }

  static const light = CustomColors(
    enabledCheckSquaredButton: Color.fromARGB(255, 45, 230, 141),
    disabledCheckSquaredButton: Color.fromARGB(255, 194, 237, 216),
  );

  static const dark = CustomColors(
    enabledCheckSquaredButton: Color.fromARGB(255, 133, 251, 194),
    disabledCheckSquaredButton: Color.fromARGB(255, 134, 165, 150),
  );
}
