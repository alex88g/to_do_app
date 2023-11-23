import 'database_helper.dart'; // Importera DatabaseHelper för att få åtkomst till databasen

// ViewModel: ToDoDataBase är viewmodel som hanterar dataöverföring mellan modellen (ToDo) och databasen.
class ToDoDataBase {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Skapa en instans av DatabaseHelper för att hantera databasåtkomst
  

  // Metod för att skapa initial data i databasen
  Future<void> createInitialData() async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    await db.transaction((txn) async {
      await txn.insert(DatabaseHelper.table, {'task': 'Do Exercise', 'completed': 0}); // Lägg till en initial uppgift i databasen
    });
  }

  // Metod för att ladda data från databasen
  Future<List<Map<String, dynamic>>> loadData() async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.table); // Hämta alla uppgifter från tabellen
    return maps;
  }

  // Metod för att uppdatera databasen med en ny lista av uppgifter
  Future<void> updateDataBase(List<Map<String, dynamic>> newList) async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    await db.delete(DatabaseHelper.table); // Radera befintlig data i tabellen
    for (var item in newList) {
      await db.insert(DatabaseHelper.table, item); // Lägg till nya uppgifter i tabellen
    }
  }

  // Metod för att lägga till en ny uppgift i databasen
  Future<void> addTask(String task) async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    await db.insert(DatabaseHelper.table, {'task': task, 'completed': 0}); // Lägg till den nya uppgiften i tabellen
  }

  // Metod för att uppdatera en specifik uppgift i databasen
  Future<void> updateTask(int id, bool completed) async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    await db.update(
      DatabaseHelper.table,
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    ); // Uppdatera statusen för den specifika uppgiften
  }

  // Metod för att uppdatera bildsökvägen för en uppgift i databasen
// I ToDoDataBase-klassen
Future<void> updateTaskImagePath(int taskId, String? imagePath) async {
  final db = await _dbHelper.database;
  await db.update(
    DatabaseHelper.table,
    {'imagePath': imagePath},
    where: 'id = ?',
    whereArgs: [taskId],
  );
}



// I ToDoDataBase-klassen
Future<String?> getTaskImagePath(int taskId) async {
  final db = await _dbHelper.database;
  final List<Map<String, dynamic>> result = await db.query(
    DatabaseHelper.table,
    columns: ['imagePath'],
    where: 'id = ?',
    whereArgs: [taskId],
  );
  if (result.isNotEmpty && result.first['imagePath'] != null) {
    return result.first['imagePath'] as String;
  }
  return null;
}



  

  // Metod för att radera en specifik uppgift från databasen
  Future<void> deleteTask(int id) async {
    final db = await _dbHelper.database; // Hämta en referens till databasen
    await db.delete(
      DatabaseHelper.table,
      where: 'id = ?',
      whereArgs: [id],
    ); // Radera den specifika uppgiften från tabellen
  }
}


