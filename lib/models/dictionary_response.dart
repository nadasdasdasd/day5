class DictionaryResponse {
  final String word;
  final String phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  DictionaryResponse({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory DictionaryResponse.fromJson(Map<String, dynamic> json) {
    return DictionaryResponse(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics: List<Phonetic>.from(
          json['phonetics'].map((x) => Phonetic.fromJson(x))),
      meanings:
          List<Meaning>.from(json['meanings'].map((x) => Meaning.fromJson(x))),
    );
  }
}

class Phonetic {
  final String text;
  final String audio;
  final String sourceUrl;
  final License license;

  Phonetic({
    required this.text,
    required this.audio,
    required this.sourceUrl,
    required this.license,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
      sourceUrl: json['sourceUrl'],
      license: License.fromJson(json['license']),
    );
  }
}

class License {
  final String name;
  final String url;

  License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions: List<Definition>.from(
          json['definitions'].map((x) => Definition.fromJson(x))),
      synonyms: List<String>.from(json['synonyms']),
      antonyms: List<String>.from(json['antonyms']),
    );
  }
}

class Definition {
  final String definition;
  final List<String> synonyms;
  final List<String> antonyms;
  final String? example;

  Definition({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      synonyms: List<String>.from(json['synonyms']),
      antonyms: List<String>.from(json['antonyms']),
      example: json['example'],
    );
  }
}
