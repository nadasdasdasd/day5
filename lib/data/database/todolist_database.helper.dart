import 'package:day4/models/todolist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

class TodolistDatabaseHelper {
  final Logger _logger = Logger();
  static final TodolistDatabaseHelper _instance =
      TodolistDatabaseHelper._internal();
  static Database? _database;

  TodolistDatabaseHelper._internal();

  factory TodolistDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_list.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE todo(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task TEXT NOT NULL
            )
          ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> tasks = await db.query('todo');
    return tasks
        .map((task) => Task(id: task['id'], task: task['task']))
        .toList();
  }

  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('todo', {'task': task.task});
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      _logger.i('Attempting to delete task with id: $id');
      final result = await db.delete('todo', where: 'id = ?', whereArgs: [id]);

      if (result == 0) {
        _logger.w('No task found with id: $id');
      } else {
        _logger.i('Task with id: $id deleted successfully');
      }
    } catch (e) {
      _logger.e('Error deleting task: $e');
    }
  }
}
