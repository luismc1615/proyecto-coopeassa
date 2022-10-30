import 'package:mongo_dart/mongo_dart.dart';

class PetsDTO {
  @override
  ObjectId? petId;

  @override
  String? name;

  @override
  String? breed;

  @override
  String? color;

  @override
  int? age;

  @override
  int? weight;

  @override
  String? profile_photo;

  @override
  String? user_id;

  PetsDTO(this.petId, this.name, this.breed, this.color, this.age, this.weight,
      this.profile_photo, this.user_id);
}
