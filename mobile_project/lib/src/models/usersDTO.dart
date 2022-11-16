import 'package:mongo_dart/mongo_dart.dart';

class UsersDTO {
  @override
  ObjectId? userId;

  @override
  String? name;

  @override
  String? email;

  @override
  String? phone;

  @override
  String? username;

  @override
  String? password;

  UsersDTO(this.userId, this.name, this.email, this.phone, this.username,
      this.password);
}
