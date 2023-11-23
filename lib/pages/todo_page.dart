import 'package:flutter/material.dart';
import '../data/todo_database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';





class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  ToDoDataBase db = ToDoDataBase();
  List<Map<String, dynamic>> toDoList = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData(); // Ladda data när sidan skapas
  }

  void loadData() async {
    var loadedToDoList = await db.loadData(); // Hämta uppgifter från databasen
    setState(() {
      toDoList = loadedToDoList;
    });
  }

  void checkBoxChanged(bool? value, int id) async {
    if (value != null) {
      await db.updateTask(id, value); // Uppdatera uppgiftens status i databasen
      loadData(); // Ladda om uppgifterna efter uppdatering
    }
  }

void saveNewTask() async {
  try {
    await db.addTask(_controller.text); // Försök att spara en ny uppgift i databasen
    _controller.clear(); // Rensa inmatningsfältet
    Navigator.of(context).pop(); // Stäng dialogrutan
    loadData(); // Ladda om uppgifterna efter att ha lagt till en ny uppgift
  } catch (e) {
    // Om något går fel, fånga och hantera felet här
    print('Fel vid sparande av uppgift: $e');
    // Du kan lägga till felhantering eller meddelanden här om du vill informera användaren om felet.
  }
}


  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask, // Spara ny uppgift när användaren klickar på "Spara"
          onCancel: () => Navigator.of(context).pop(), // Avbryt och stäng dialogrutan
        );
      },
    );
  }

  void deleteTask(int id) async {
    await db.deleteTask(id); // Radera en uppgift från databasen
    loadData(); // Ladda om uppgifterna efter radering
  }

 Future<void> pickImage(int taskId) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newPath = '${appDir.path}/${DateTime.now().toIso8601String()}_${image.name}';
    final File newImage = await File(image.path).copy(newPath);

    // Uppdatera bildsökvägen i databasen för den specifika uppgiften
    await db.updateTaskImagePath(taskId, newImage.path);

    // Ladda om uppgifterna efter att ha sparat bilden
    loadData();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('TO DO'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask, // Visa dialogruta för att skapa ny uppgift
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return TodoApp(
            taskId: toDoList[index]['id'], // Skicka med uppgiftens ID till TodoApp-widgeten
            taskName: toDoList[index]['task'],
            taskCompleted: toDoList[index]['completed'] == 1,
            onChanged: (value) {
              checkBoxChanged(value, toDoList[index]['id']); // Uppdatera uppgiften när checkboxen ändras
            },
            deleteFunction: (ctx) {
              deleteTask(toDoList[index]['id']); // Radera uppgiften när användaren klickar på "Radera"
            },
            pickImage: () {
              pickImage(toDoList[index]['id']); // Anropa pickImage när användaren vill ladda upp en bild
            },
          );
        },
      ),
    );
  }
}
