import 'package:flutter/material.dart';
import 'package:aviato_finance/utils/colors.dart';

enum ButtonType {
  primary,
  secondary,
  contrast,
  // agrega más como danger, warning, etc. Si es necesario...
}

// crea un par { bColor, tColor } para un default de texto y color de botón
class ButtonColorPair {
  final Color buttonColor;
  final Color textColor;

  ButtonColorPair({required this.buttonColor, required this.textColor});
}

class ButtonColorsSelector {
  static ButtonColorPair getColorsFromType(ButtonType type, bool dark) {
    switch (type) {
      case ButtonType.primary:
        return ButtonColorPair(
          buttonColor: dark ? customGreenDarker : customGreen,
          textColor: Colors.white,
        );
      case ButtonType.secondary:
        return ButtonColorPair(
          buttonColor: dark ? customRedDarker : customGreen,
          textColor: Colors.white,
        );
      case ButtonType.contrast:
        return ButtonColorPair(
          buttonColor: Colors.white,
          textColor: Colors.black,
        );
    }
  }
}

class ApplicationButton extends StatelessWidget {
  final Widget child;
  final ButtonType type;
  final VoidCallback? onPressed;
  final bool? isDark;

  const ApplicationButton({
    super.key,
    required this.child,
    required this.type,
    this.onPressed,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    ButtonColorPair buttonColorPair = ButtonColorsSelector.getColorsFromType(
      type,
      isDark != null && isDark == true,
    );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: buttonColorPair.buttonColor,
        foregroundColor: buttonColorPair.textColor,
        minimumSize: Size(100, 60), // Ancho de 200 y alto de 60
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
