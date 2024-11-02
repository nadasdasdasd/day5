import 'package:day4/data/database/todolist_database.helper.dart';
import 'package:day4/models/favorite_word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteWordCubit extends Cubit {
  final TodolistDatabaseHelper _databaseHelper = TodolistDatabaseHelper();

  FavoriteWordCubit() : super([]) {
    _loadFavoriteWord();
  }

  void _loadFavoriteWord() async {
    final tasks = await _databaseHelper.getFavoriteWords();
    emit(tasks);
  }

  void addFavoriteWord(FavoriteWord word) async {
    if (word.word.isNotEmpty) {
      await _databaseHelper.insertFavoriteWord(word);
      _loadFavoriteWord();
    }
  }

  void deleteFavoriteWord(int id) async {
    await _databaseHelper.deleteFavoriteWord(id);
    _loadFavoriteWord();
  }

  Future<bool> isFavorite(String word) async {
    final favoriteWords = await _databaseHelper.getFavoriteWords();
    return favoriteWords.any((favorite) => favorite.word == word);
  }
}
