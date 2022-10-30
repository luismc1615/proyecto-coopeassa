import 'package:mongo_dart/mongo_dart.dart';

class PhotosTravelDTO {
  @override
  ObjectId? photoTravelId;

  @override
  String? photo;

  @override
  String? travel_id;

  PhotosTravelDTO(this.photoTravelId, this.photo, this.travel_id);
}
