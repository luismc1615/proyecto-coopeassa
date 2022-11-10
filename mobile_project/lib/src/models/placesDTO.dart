import 'package:mongo_dart/mongo_dart.dart';

class PlacesDTO {
  @override
  ObjectId? placeId;

  @override
  String? address;

  @override
  String? description;

  @override
  String? profile_img;

  @override
  String? name;

  PlacesDTO(this.placeId, this.address, this.description, this.profile_img, this.name);
}
