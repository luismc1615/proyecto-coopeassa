import 'package:mongo_dart/mongo_dart.dart';

class ImagesPlacesDTO {
  @override
  ObjectId? imgPlaceId;

  @override
  String? img;

  @override
  String? placeId;

  ImagesPlacesDTO(this.imgPlaceId, this.img, this.placeId);
}
