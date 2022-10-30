import 'package:mongo_dart/mongo_dart.dart';

class RelationshipsDTO {
  @override
  ObjectId? relationshipId;

  @override
  String? name;

  @override
  String? breed;

  @override
  String? color;

  @override
  int? age;

  @override
  String? relationship;

  @override
  String? profile_photo;

  @override
  String? pet_id;

  RelationshipsDTO(this.relationshipId, this.name, this.breed, this.color, this.age, this.relationship,
      this.profile_photo, this.pet_id);
}
