import 'package:day4/models/favorite_word.dart';
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
        await db.execute('''
          CREATE TABLE favorite_words(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            phonetic TEXT,
            synonyms TEXT,
            antonyms TEXT,
            definitions TEXT
          )
        ''');
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < 4) {
      //     await db.execute('''
      //     CREATE TABLE favorite_words(
      //       id INTEGER PRIMARY KEY AUTOINCREMENT,
      //       word TEXT NOT NULL,
      //       phonetic TEXT,
      //       synonyms TEXT,
      //       antonyms TEXT,
      //       definitions TEXT
      //     )
      //   ''');
      //   }
      // },
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

  //insert favorite word
  Future<void> insertFavoriteWord(FavoriteWord word) async {
    final db = await database;
    await db.insert('favorite_words', word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavoriteWord>> getFavoriteWords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite_words');
    return List.generate(maps.length, (index) {
      return FavoriteWord.fromMap(maps[index]);
    });
  }

  Future<void> deleteFavoriteWord(int id) async {
    try {
      final db = await database;
      _logger.i("attemp to delete favorite word id $id");
      final result =
          await db.delete('favorite_words', where: 'id = ?', whereArgs: [id]);
      if (result == 0) {
        _logger.w('no favorite word found');
      } else {
        _logger.i('successfully deleted favorite word id $id');
      }
    } catch (e) {
      _logger.e('error deleting favorite word id $id');
    }
  }
}
