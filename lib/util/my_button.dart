import 'package:flutter/material.dart';

// Detta är huvudsakligen en View-komponent som representerar användargränssnittet för att visa och interagera med uppgifter.
class MyButton extends StatelessWidget {
  final String text; // Text som visas på knappen
  final VoidCallback onPressed; // Funktion som körs när knappen trycks
  final TextStyle? textStyle; // Anpassad textstil för knappens text
  final Color? buttonColor; // Anpassad bakgrundsfärg för knappen
  final double? width; // Anpassad bredd för knappen
  final double? height; // Anpassad höjd för knappen

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.buttonColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final defaultButtonColor = theme.primaryColor;

    return MaterialButton(
      onPressed: onPressed, // Funktionen som körs när knappen trycks
      color: buttonColor ?? defaultButtonColor, // Knappens bakgrundsfärg (standard: primärfärgen i temat)
      minWidth: width, // Knappens bredd (kan vara null för automatisk storlek)
      height: height, // Knappens höjd (kan vara null för automatisk storlek)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Anpassad form för knappen (rundade hörn)
      ),
      child: Text(
        text, // Text som visas på knappen
        style: textStyle ?? const TextStyle(color: Colors.white), // Textstil för knappens text (standard: vit text)
      ),
    );
  }
}
