import 'package:day4/blocs/apicubit/api_cubit.dart';
import 'package:day4/blocs/favorite_word/favorite_word_cubit.dart';
import 'package:day4/helper/network_service.dart';
import 'package:day4/models/favorite_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryScreen extends StatelessWidget {
  final String? word; // Optional word parameter
  final bool cameFromFavorites; // New parameter to indicate source

  const DictionaryScreen(
      {super.key, this.word, this.cameFromFavorites = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ApiCubit(NetworkService())),
            BlocProvider(create: (_) => FavoriteWordCubit()),
          ],
          child: DictionaryWidget(
              word: word, cameFromFavorites: cameFromFavorites)),
    );
  }
}

class DictionaryWidget extends StatelessWidget {
  final String? word; // Optional word parameter
  final bool cameFromFavorites; // New parameter to indicate source

  DictionaryWidget(
      {super.key, this.word, this.cameFromFavorites = false}); // Constructor

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final apiCubit = context.read<ApiCubit>();
    String enteredWord = word ?? ""; // Use the passed word or an empty string
    final favoriteWordCubit = context.read<FavoriteWordCubit>();

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
              initialValue: enteredWord, // Pre-fill with the passed word
              onChanged: (value) {
                enteredWord = value; // Update enteredWord on change
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
                  apiCubit.fetchData('/$enteredWord');
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
                            ...response.meanings.expand((meaning) =>
                                meaning.definitions.map((definition) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text('• ${definition.definition}'),
                                  );
                                })),
                            const SizedBox(height: 10),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       final favoriteWord = FavoriteWord(
                            //           word: response.word,
                            //           phonetic: response.phonetic,
                            //           synonyms: response.meanings
                            //               .expand((m) => m.synonyms)
                            //               .join(),
                            //           antonyms: response.meanings
                            //               .expand((m) => m.antonyms)
                            //               .join(),
                            //           definitions: response.meanings
                            //               .expand((m) => m.definitions)
                            //               .join());
                            //       favoriteWordCubit
                            //           .addFavoriteWord(favoriteWord);
                            //       ScaffoldMessenger.of(context)
                            //           .showSnackBar(SnackBar(
                            //         content: Text(
                            //             '${response.word} added to favorites!'),
                            //         duration: const Duration(seconds: 2),
                            //       ));
                            //     },
                            //     child: const Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Icon(Icons.bookmark_add),
                            //         Text('Add to favorite')
                            //       ],
                            //     )),
                            FutureBuilder<bool>(
                              future:
                                  favoriteWordCubit.isFavorite(response.word),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error checking favorite status');
                                } else if (snapshot.data == false) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        final favoriteWord = FavoriteWord(
                                            word: response.word,
                                            phonetic: response.phonetic,
                                            synonyms: response.meanings
                                                .expand((m) => m.synonyms)
                                                .join(),
                                            antonyms: response.meanings
                                                .expand((m) => m.antonyms)
                                                .join(),
                                            definitions: response.meanings
                                                .expand((m) => m.definitions)
                                                .join());
                                        favoriteWordCubit
                                            .addFavoriteWord(favoriteWord);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              '${response.word} added to favorites!'),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.bookmark_add),
                                          Text('Add to favorite'),
                                        ],
                                      ));
                                }
                                return Container();
                              },
                            ),
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
