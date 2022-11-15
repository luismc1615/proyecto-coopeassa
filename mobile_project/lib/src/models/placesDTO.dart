import 'package:mongo_dart/mongo_dart.dart';

class PlacesDTO {
  @override
  ObjectId? placeId;

  @override
  String? address;

  @override
  String? description;

  @override
  String? name;

  @override
  String? profile_img;

  @override
  String? activities;

  PlacesDTO(this.placeId, this.address, this.description, this.name, this.profile_img, this.activities);
}
