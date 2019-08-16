import 'package:flutter/foundation.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  String phone;
  String profileUrl;

  User();

  User.register({@required this.name,
    @required this.email,
    @required this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    password = json["password"];
    phone = json["phone"];
    profileUrl = json["profileUrl"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "profileUrl": profileUrl
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Usuário: (id: $id, name: $name, email: $email, phone: $phone, img: $profileUrl)";
  }
}
