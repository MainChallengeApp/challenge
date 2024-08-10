class AccountModel {
  String username;

  AccountModel({required this.username});

  static AccountModel fromDoc(doc) => AccountModel(username: doc['email']);

  Map<String, dynamic> toDoc() {
    return {'email': username};
  }

  static bool isValidUsername(String username) {
    if (username.isEmpty) {
      return false;
    }
    return true;
  }
}
