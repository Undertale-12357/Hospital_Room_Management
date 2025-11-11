import '../../domain/entities/room.dart';
import '../../domain/entities/bed.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/patient.dart';

class RoomModel {
  final String room_id;
  final String room_number;
  final room_type type;
  final List<Bed> beds;

  RoomModel({
    required this.room_id,
    required this.room_number,
    required this.type,
    required this.beds,
  });

  factory RoomModel.from_entity(Room room) => RoomModel(
        room_id: room.room_id,
        room_number: room.room_number,
        type: room.type,
        beds: room.beds,
      );

  Room to_entity() => Room(
        room_id: room_id,
        room_number: room_number,
        number_of_beds: beds.length,
        type: type,
      )..beds.setAll(0, beds);

  Map<String, dynamic> to_json() => {
        'room_id': room_id,
        'type': type.name,
        'beds': beds.map((b) => {
              'bed_number': b.bed_number,
              'status': b.status.name,
              'patient': b.patient?.to_json(),
            }).toList(),
      };

  factory RoomModel.from_json(Map<String, dynamic> json) {
    final bed_list = (json['beds'] as List)
        .map((b) => Bed(
              bed_number: b['bed_number'],
              status: bed_status.values.firstWhere((e) => e.name == b['status']),
              patient: b['patient'] != null
                  ? Patient.from_json(b['patient'])
                  : null,
            ))
        .toList();

    return RoomModel(
      room_id: json['room_id'],
      room_number: json['room_number'],
      type: room_type.values.firstWhere((e) => e.name == json['type']),
      beds: bed_list,
    );
  }
}
