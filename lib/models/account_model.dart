class AccountModel {
  String? email;

  AccountModel({this.email});

  static AccountModel fromJson(json) => AccountModel(email: json['email']);

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
