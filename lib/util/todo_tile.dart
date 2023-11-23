import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/todo_database.dart'; // Importera din ToDoDataBase-klass
import 'dart:io';

//import 'package:shared_preferences/shared_preferences.dart';


// Detta är huvudsakligen en View-komponent som representerar användargränssnittet för att visa och interagera med uppgifter
class TodoApp extends StatefulWidget {
  final int taskId;
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final void Function(BuildContext)? deleteFunction;
   final void Function()? pickImage; // Lägg till pickImage som ett fält

  const TodoApp({
  Key? key,
  required this.taskId,
  required this.taskName,
  required this.taskCompleted,
  this.onChanged,
  this.deleteFunction,
  required this.pickImage, // Lägg till pickImage här
}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late bool isCompleted;
  late tz.TZDateTime lastUpdated;
  String? imagePath;

  _TodoAppState() {
    lastUpdated = _getCurrentTimeInEurope();
  }

  tz.TZDateTime _getCurrentTimeInEurope() {
    var nowUTC = tz.TZDateTime.now(tz.UTC);
    var parisTimeZone = tz.getLocation('Europe/Paris');
    return tz.TZDateTime.from(nowUTC, parisTimeZone);
  }

 // I TodoApp-klassens State
 Future<void> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newPath = '${appDir.path}/${DateTime.now().toIso8601String()}_${image.name}';
    final File newImage = await File(image.path).copy(newPath);

    // Spara den nya sökvägen i widgetens tillstånd
    setState(() {
      imagePath = newImage.path;
    });

    // Uppdatera sökvägen i databasen
    await ToDoDataBase().updateTaskImagePath(widget.taskId, newImage.path);
  }
}


@override
void initState() {
 super.initState();
  isCompleted = widget.taskCompleted;
  _loadImagePath();
  print('initState: Image Path: $imagePath'); // Anropa _loadImagePath när appen startas
}
Future<void> _loadImagePath() async {
  print('Före hämtning av bildsökväg');
  String? savedImagePath = await ToDoDataBase().getTaskImagePath(widget.taskId);
  print('Efter hämtning av bildsökväg: Saved Image Path: $savedImagePath');
  if (savedImagePath != null) {
    setState(() {
      imagePath = savedImagePath;
    });
  } else {
    // Om det inte finns någon sparad bildsökväg, sätt imagePath till null eller en tom sökväg
    setState(() {
      imagePath = null; // Visa ingen bild om ingen bild är sparad
    });
  }
}




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.01)
            ..rotateY(0.02),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 228, 52, 8),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor: const Color.fromRGBO(253, 7, 7, 1),
                      ),
                      child: Checkbox(
                        value: isCompleted,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            setState(() => isCompleted = newValue);
                            if (widget.onChanged != null) {
                              widget.onChanged!(newValue);
                            }
                          }
                        },
                        activeColor: const Color.fromRGBO(253, 7, 7, 1),
                        checkColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.taskName,
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? const Color.fromRGBO(253, 7, 7, 1)
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(lastUpdated),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                IconButton(
  icon: const Icon(Icons.camera_alt),
  onPressed: () {
    pickImage(); // Anropa pickImage när användaren vill ladda upp en bild
  },
),
            ],
          ),
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(File(imagePath!)), // Visar den valda bilden
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
