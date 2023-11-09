class Account {
  String? email;

  Account({this.email});

  static Account fromJson(json) => Account(email: json['email']);

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
