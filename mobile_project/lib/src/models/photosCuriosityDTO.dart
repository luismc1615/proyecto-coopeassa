import 'package:mongo_dart/mongo_dart.dart';

class PhotosCuriosityDTO {
  @override
  ObjectId? photoCuriositylId;

  @override
  String? photo;

  @override
  String? curiosity_id;

  PhotosCuriosityDTO(this.photoCuriositylId, this.photo, this.curiosity_id);
}
