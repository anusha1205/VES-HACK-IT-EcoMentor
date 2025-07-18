class Player {
  final String name;
  final String avatar;
  int score;
  int streak;

  Player({
    required this.name,
    this.avatar = '👤',
    this.score = 0,
    this.streak = 0,
  });
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int points;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.points = 10,
  });
}

class JumbledWord {
  final String word;
  final String hint;
  final String explanation;
  final int points;
  final int level;
  late String jumbledWord;

  JumbledWord({
    required this.word,
    required this.hint,
    required this.explanation,
    int? points,  
    required this.level,
  }) : points = points ?? (level == 1 ? 10 : level == 2 ? 20 : 30) {  
    jumbledWord = _jumbleWord(word);
  }

  String _jumbleWord(String word) {
    List<String> characters = word.split('');
    characters.shuffle();
    String jumbled = characters.join();
    while (jumbled == word && word.length > 1) {
      characters.shuffle();
      jumbled = characters.join();
    }
    return jumbled;
  }
}
