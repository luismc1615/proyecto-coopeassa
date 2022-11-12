import 'package:mongo_dart/mongo_dart.dart';

class ReservationsDTO {
  @override
  ObjectId? reservationId;

  @override
  String? placeId;

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
  String? userId;

  ReservationsDTO(this.reservationId, this.placeId, this.personQuantiti, this.checkInTime,
      this.checkOutTime, this.phone, this.email, this.address, this.userId);
}
