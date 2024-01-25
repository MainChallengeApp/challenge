class AccountModel {
  String? username;

  AccountModel({this.username});

  static AccountModel fromJson(json) => AccountModel(username: json['email']);

  Map<String, dynamic> toJson() {
    return {'email': username};
  }

  static bool isValidUsername(String username) {
    if (username.isEmpty) {
      return false;
    }
    return true;
  }
}
