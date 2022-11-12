import 'package:mongo_dart/mongo_dart.dart';

class ReservationsDTO {
  @override
  ObjectId? reservationId;

  @override
  int? personQuantiti;

  @override
  String? checkInTime;

  @override
  String? checkOutTime;

  @override
  String? phone;

  @override
  String? email;

  @override
  String? address;

  @override
  String? place;

  @override
  String? profile;

  @override
  String? date;

  ReservationsDTO(this.reservationId, this.personQuantiti, this.checkInTime,
      this.checkOutTime, this.phone, this.email, this.address, this.place, this.profile, this.date);
}
