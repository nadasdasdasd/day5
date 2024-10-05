import 'package:day4/blocs/todolist/todolist_cubit.dart';
import 'package:day4/screens/AddToDoListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ToDoListAppCubit(),
        child: const TodoListAppHomepage(),
      ),
    );
  }
}

class TodoListAppHomepage extends StatelessWidget {
  const TodoListAppHomepage({super.key});
  @override
  Widget build(BuildContext context) {
    final ToDoListAppCubit todoListCubit =
        BlocProvider.of<ToDoListAppCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: BlocBuilder<ToDoListAppCubit, List<String>>(
          builder: (context, state) {
        return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              final task = state[index];
              return ListTile(
                title: Text(task),
                onTap: () => todoListCubit.deleteTask(index),
              );
            });
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final task = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddToDoListScreen();
              }));
              if (task != null && context.mounted) {
                todoListCubit.addTask(task);
              }
            },
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
