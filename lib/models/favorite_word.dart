class FavoriteWord {
  final int? id;
  final String word;
  final String phonetic;
  final String synonyms;
  final String antonyms;
  final String definitions;

  FavoriteWord({
    this.id,
    required this.word,
    required this.phonetic,
    required this.synonyms,
    required this.antonyms,
    required this.definitions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'phonetic': phonetic,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'definitions': definitions,
    };
  }

  factory FavoriteWord.fromMap(Map<String, dynamic> map) {
    return FavoriteWord(
      id: map['id'],
      word: map['word'],
      phonetic: map['phonetic'],
      synonyms: map['synonyms'],
      antonyms: map['antonyms'],
      definitions: map['definitions'],
    );
  }
}
