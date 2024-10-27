import 'package:day4/blocs/todolist/todolist_cubit.dart';
import 'package:day4/consts/app_route.dart';
import 'package:day4/models/todolist.dart';
import 'package:day4/screens/AddToDoListScreen.dart';
import 'package:day4/screens/DictionaryScreen.dart';
import 'package:day4/screens/ProfileScreen.dart';
import 'package:day4/screens/SettingScreen.dart';
import 'package:day4/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.splashScreen,
      routes: {
        AppRoute.splashScreen: (context) => const SplashScreen(),
        AppRoute.addTodoList: (context) => const AddToDoListScreen(),
        AppRoute.mainScreen: (context) => const TodoListApp(),
      },
    );
  }
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const TodoListAppHomepage(),
    const ProfileScreen(),
    DictionaryScreen(),
    const Settingscreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoListAppCubit(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.purpleAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Dictionary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.purpleAccent,
          onTap: _onItemTapped,
        ),
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
      body: BlocBuilder<ToDoListAppCubit, List<Task>>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              final task = state[index];
              return GestureDetector(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (GestureDetectorState.isTapping) {
                      _confirmDelete(context, task, todoListCubit);
                    }
                  });
                },
                onLongPress: () {
                  GestureDetectorState.isTapping = false;
                },
                child: ListTile(
                  title: Text(task.task),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AddToDoListScreen();
          }));
          if (task != null && context.mounted) {
            final newTask = Task(id: 0, task: task);
            todoListCubit.addTask(newTask);
          }
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, Task task, ToDoListAppCubit todoListCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.task}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoListCubit.deleteTask(task.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class GestureDetectorState {
  static bool isTapping = true;
}
