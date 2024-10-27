import 'package:day4/blocs/apicubit/api_cubit.dart';
import 'package:day4/helper/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
            create: (_) => ApiCubit(NetworkService()),
            child: DictionaryWidget()));
  }
}

class DictionaryWidget extends StatelessWidget {
  DictionaryWidget({super.key}); // Make sure to use the const constructor
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final apiCubit = context.read<ApiCubit>();
    String word = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary Example'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              onChanged: (value) {
                word = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a word!';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter word here ...',
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  apiCubit.fetchData('/$word');
                }
              },
              child: const Text('Translate to English'),
            ),
            BlocBuilder<ApiCubit, ApiState>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const CircularProgressIndicator();
                } else if (state is ApiSuccess) {
                  final response = state
                      .response; // Assuming your response is set up this way
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(
                              'Word: ${response.word}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Phonetic: ${response.phonetic}',
                              style: const TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Synonyms: ${response.meanings.expand((m) => m.synonyms).join(', ')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Antonyms: ${response.meanings.expand((m) => m.antonyms).join(', ')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Definitions:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ...response.meanings
                                .expand((meaning) =>
                                    meaning.definitions.map((definition) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child:
                                            Text('• ${definition.definition}'),
                                      );
                                    }))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is ApiFailure) {
                  return const Column(
                    children: [
                      SizedBox(height: 15),
                      Text('No result.'),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
