import 'package:flutter/material.dart';

class AddToDoListScreen extends StatefulWidget {
  const AddToDoListScreen({super.key});

  @override
  AddToDoListScreenState createState() => AddToDoListScreenState();
}

class AddToDoListScreenState extends State<AddToDoListScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String task = "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Add a task'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                onChanged: (value) {
                  task = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a task!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Enter something todo ...',
                    contentPadding: EdgeInsets.all(16.0)),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop(task);
                    }
                  },
                  child: const Text('Add Task'))
            ],
          )),
    );
  }
}
