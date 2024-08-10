class UserModel {
  final String id;
  final String email;
  final String username;
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
  });

  static fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
          id: map['id'],
          email: map['email'],
          username: map['username'],
          name: map['name']);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
    };
  }
}
