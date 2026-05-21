class User {
  int? id;
  String username;
  String password;
  String email;
  int score;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    this.score = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'score': score,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      score: map['score'] ?? 0,
    );
  }
}
