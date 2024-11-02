import 'package:day4/blocs/favorite_word/favorite_word_cubit.dart';
import 'package:day4/blocs/todolist/todolist_cubit.dart';
import 'package:day4/consts/app_route.dart';
import 'package:day4/models/favorite_word.dart';
import 'package:day4/models/todolist.dart';
import 'package:day4/screens/AddToDoListScreen.dart';
import 'package:day4/screens/DictionaryScreen.dart';
import 'package:day4/screens/ProfileScreen.dart';
import 'package:day4/screens/SettingScreen.dart';
import 'package:day4/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  final List<Widget> _pages = const [
    MainHomepage(),
    ProfileScreen(),
    DictionaryScreen(),
    SettingScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ToDoListAppCubit()),
        BlocProvider(create: (context) => FavoriteWordCubit()),
      ],
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

class MainHomepage extends StatelessWidget {
  const MainHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: TodoListAppHomepage()), // Use Expanded correctly
          SizedBox(height: 16),
          Expanded(child: FavoriteWordsWidget()), // Use Expanded correctly
        ],
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
        // Specify the state type
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final task = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const AddToDoListScreen();
                    }),
                  );
                  if (task != null && context.mounted) {
                    final newTask = Task(id: 0, task: task);
                    todoListCubit.addTask(newTask);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          );
        },
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

class FavoriteWordsWidget extends StatelessWidget {
  const FavoriteWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteWordCubit favoriteWordCubit =
        BlocProvider.of<FavoriteWordCubit>(context);

    return BlocBuilder<FavoriteWordCubit, dynamic>(
      // Specify the state type
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Favorite Words',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  final word = state[index];
                  return ListTile(
                    title: Text(word.word),
                    onTap: () {
                      // Navigate to the DictionaryScreen, indicating it came from Favorites
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DictionaryScreen(
                              word: word.word, cameFromFavorites: true),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.delete), // Change the icon as needed
                      onPressed: () {
                        _confirmDelete(context, word, favoriteWordCubit);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FavoriteWord word,
      FavoriteWordCubit favoriteWordCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Favorite word'),
          content: Text('Are you sure you want to delete "${word.word}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                favoriteWordCubit.deleteFavoriteWord(word.id!);
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
