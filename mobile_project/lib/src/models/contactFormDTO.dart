import 'package:mongo_dart/mongo_dart.dart';

class ContactFormDTO {
  @override
  ObjectId? userId;

  @override
  String? name;

  @override
  String? nacionality;

  @override
  String? phone;

  @override
  String? email;

  @override
  String? address;

  @override
  String? description;

  ContactFormDTO(this.userId, this.name, this.nacionality, this.phone, this.email,
      this.address, this.description);
}
