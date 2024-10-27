import 'package:day4/data/database/todolist_database.helper.dart';
import 'package:day4/models/todolist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoListAppCubit extends Cubit<List<Task>> {
  final TodolistDatabaseHelper _databaseHelper = TodolistDatabaseHelper();

  ToDoListAppCubit() : super([]) {
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await _databaseHelper.getTasks();
    emit(tasks);
  }

  void addTask(Task task) async {
    if (task.task.isNotEmpty) {
      await _databaseHelper.addTask(task); // Save task with auto-increment ID
      _loadTasks(); // Refresh task list
    }
  }

  void deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
    _loadTasks(); // Refresh task list
  }
}
