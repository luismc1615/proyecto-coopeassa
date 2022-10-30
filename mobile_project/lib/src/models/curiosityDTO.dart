import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CuriosityDTO {
  @override
  ObjectId? curiosityId;

  @override
  String? title;

  @override
  String? description;

  @override
  String date;

  @override
  String? place;

  @override
  String? participants;

  @override
  String? user_id;

  CuriosityDTO(this.curiosityId, this.title, this.description, this.date,
      this.participants, this.place, this.user_id);
}
