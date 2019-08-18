import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Client {
  int id;
  String name;
  String email;
  String cpfCnpj;
  String phone1;
  String phone2;
  int classificacao = 0;

  Client();

  Client.customer(this.name, this.email, this.cpfCnpj, this.phone1, this.phone2,
      this.classificacao);

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    cpfCnpj = json['cpfCnpj'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    classificacao = json['classificacao'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': this.name,
      'email': this.email,
      'cpfCnpj': this.cpfCnpj,
      'phone1': this.phone1,
      'phone2': this.phone2,
      'classificacao': this.classificacao,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Client{id: $id, name: $name, email: $email, cpfCnpj: $cpfCnpj, phone1: $phone1, phone2: $phone2, classificacao: $classificacao}';
  }
}
