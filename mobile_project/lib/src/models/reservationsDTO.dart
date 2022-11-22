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
  String? place;

  @override
  String? profile;

  @override
  String? entryDate;

  @override
  String? departureDate;

  ReservationsDTO(
      this.reservationId,
      this.personQuantiti,
      this.checkInTime,
      this.checkOutTime,
      this.place,
      this.profile,
      this.entryDate,
      this.departureDate,
      );
}
