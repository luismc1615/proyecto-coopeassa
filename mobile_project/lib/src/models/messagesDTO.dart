import 'package:mongo_dart/mongo_dart.dart';

class MessagesDTO {
  @override
  ObjectId? messageId;

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

  MessagesDTO(this.messageId, this.name, this.nacionality, this.phone, this.email,
      this.address, this.description);
}