import 'package:mongo_dart/mongo_dart.dart';

class PetsWalkDTO {
  @override
  ObjectId? petWalkId;

  @override
  String date;

  @override
  String? place;

  @override
  String? start_time;

  @override
  String? end_time;

  @override
  String? weather;

  @override
  String? participants;

  @override
  String? user_id;

  PetsWalkDTO(this.petWalkId, this.date, this.place, this.start_time, this.end_time, this.weather,
      this.participants, this.user_id);
}