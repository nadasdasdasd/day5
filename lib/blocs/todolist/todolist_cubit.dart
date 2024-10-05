import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoListAppCubit extends Cubit<List<String>> {
  ToDoListAppCubit() : super([]);
  void addTask(String task) {
    if (task.isNotEmpty) {
      state.add(task);
      emit(List.from(state));
    }
  }

  void deleteTask(int index) {
    state.removeAt(index);
    emit(List.from(state));
  }
}
