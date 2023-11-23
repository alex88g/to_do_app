import 'package:flutter/material.dart';
import 'my_button.dart';

// Detta är huvudsakligen en View-komponent som representerar användargränssnittet för att visa och interagera med uppgifter.
// En anpassad dialogruta-widget för att lägga till nya uppgifter
class DialogBox extends StatelessWidget {
  final TextEditingController controller; // En kontroller för att hantera textinmatning
  final VoidCallback onSave; // En funktion som körs när användaren klickar på "Spara" knappen
  final VoidCallback onCancel; // En funktion som körs när användaren klickar på "Avbryt" knappen

  // Konstruktor för DialogBox-widget
  const DialogBox({
    super.key,
    required this.controller, // Kräver en kontroller
    required this.onSave, // Kräver en funktion för att spara uppgiften
    required this.onCancel, // Kräver en funktion för att avbryta och stänga dialogrutan
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1), // Bakgrundsfärg för dialogrutan
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Användarinput via en textinmatningsruta
            TextField(
              controller: controller, // Använd den angivna kontrollern för textinmatningen
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write a new task", // Platsförhållandestips i textinmatningsrutan
              ),
            ),

            // Knappar för att spara och avbryta
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Spara-knapp
                MyButton(text: "Save", onPressed: onSave), // Använd MyButton-widget för att skapa knappen

                const SizedBox(width: 8), // En tom yta mellan knapparna

                // Avbryt-knapp
                MyButton(text: "Cancel", onPressed: onCancel), // Använd MyButton-widget för att skapa knappen
              ],
            ),
          ],
        ),
      ),
    );
  }
}
