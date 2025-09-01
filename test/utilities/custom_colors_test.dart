
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/utilities/my_colors.dart';

void main() {
  group('CustomColors', () {
    test('light theme colors are correctly defined', () {
      const lightColors = CustomColors.light;
      expect(lightColors.enabledCheckSquaredButton, const Color.fromARGB(255, 45, 230, 141));
      expect(lightColors.disabledCheckSquaredButton, const Color.fromARGB(255, 194, 237, 216));
      expect(lightColors.enabledUndoSquaredButton, const Color.fromARGB(255, 213, 40, 28));
      expect(lightColors.disabledUndoSquaredButton, const Color.fromARGB(255, 255, 191, 186));
    });

    test('dark theme colors are correctly defined', () {
      const darkColors = CustomColors.dark;
      expect(darkColors.enabledCheckSquaredButton, const Color.fromARGB(255, 133, 251, 194));
      expect(darkColors.disabledCheckSquaredButton, const Color.fromARGB(255, 134, 165, 150));
      expect(darkColors.enabledUndoSquaredButton, const Color.fromARGB(255, 252, 81, 69));
      expect(darkColors.disabledUndoSquaredButton, const Color.fromARGB(255, 152, 66, 60));
    });

    test('copyWith creates a new instance with updated values', () {
      const originalColors = CustomColors.light;
      final copiedColors = originalColors.copyWith(
        enabledCheckSquaredButton: Colors.blue,
        disabledCheckSquaredButton: Colors.red,
        enabledUndoSquaredButton: Colors.green,
        disabledUndoSquaredButton: Colors.yellow,
      );

      expect(copiedColors.enabledCheckSquaredButton, Colors.blue);
      expect(copiedColors.disabledCheckSquaredButton, Colors.red);
      expect(copiedColors.enabledUndoSquaredButton, Colors.green);
      expect(copiedColors.disabledUndoSquaredButton, Colors.yellow);
    });

    test('copyWith creates a new instance with some null values', () {
      const originalColors = CustomColors.light;
      final copiedColors = originalColors.copyWith(
        enabledCheckSquaredButton: Colors.blue,
        disabledCheckSquaredButton: null,
        enabledUndoSquaredButton: Colors.green,
        disabledUndoSquaredButton: null,
      );

      expect(copiedColors.enabledCheckSquaredButton, Colors.blue);
      expect(copiedColors.disabledCheckSquaredButton, originalColors.disabledCheckSquaredButton);
      expect(copiedColors.enabledUndoSquaredButton, Colors.green);
      expect(copiedColors.disabledUndoSquaredButton, originalColors.disabledUndoSquaredButton);
    });

    test('copyWith creates a new instance with all null values', () {
      const originalColors = CustomColors.light;
      final copiedColors = originalColors.copyWith(
        enabledCheckSquaredButton: null,
        disabledCheckSquaredButton: null,
        enabledUndoSquaredButton: null,
        disabledUndoSquaredButton: null,
      );

      expect(copiedColors.enabledCheckSquaredButton, originalColors.enabledCheckSquaredButton);
      expect(copiedColors.disabledCheckSquaredButton, originalColors.disabledCheckSquaredButton);
      expect(copiedColors.enabledUndoSquaredButton, originalColors.enabledUndoSquaredButton);
      expect(copiedColors.disabledUndoSquaredButton, originalColors.disabledUndoSquaredButton);
    });

    test('copyWith creates a new instance with all values updated', () {
      const originalColors = CustomColors.light;
      final copiedColors = originalColors.copyWith(
        enabledCheckSquaredButton: Colors.blue,
        disabledCheckSquaredButton: Colors.red,
        enabledUndoSquaredButton: Colors.green,
        disabledUndoSquaredButton: Colors.yellow,
      );

      expect(copiedColors.enabledCheckSquaredButton, Colors.blue);
      expect(copiedColors.disabledCheckSquaredButton, Colors.red);
      expect(copiedColors.enabledUndoSquaredButton, Colors.green);
      expect(copiedColors.disabledUndoSquaredButton, Colors.yellow);
    });

    test('lerp interpolates colors correctly', () {
      const color1 = CustomColors.light;
      const color2 = CustomColors.dark;

      final lerpedColors = color1.lerp(color2, 0.5);

      expect(lerpedColors.enabledCheckSquaredButton, Color.lerp(color1.enabledCheckSquaredButton, color2.enabledCheckSquaredButton, 0.5));
      expect(lerpedColors.disabledCheckSquaredButton, Color.lerp(color1.disabledCheckSquaredButton, color2.disabledCheckSquaredButton, 0.5));
      expect(lerpedColors.enabledUndoSquaredButton, Color.lerp(color1.enabledUndoSquaredButton, color2.enabledUndoSquaredButton, 0.5));
      expect(lerpedColors.disabledUndoSquaredButton, Color.lerp(color1.disabledUndoSquaredButton, color2.disabledUndoSquaredButton, 0.5));
    });
  });
}
