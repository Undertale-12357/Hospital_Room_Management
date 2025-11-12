import '../../domain/entities/room.dart';
import '../../domain/entities/enums.dart';
import 'bed_model.dart';

class RoomModel {
  final String room_id;
  final String room_number;
  final String type; 
  final List<BedModel> beds;

  RoomModel({
    required this.room_id,
    required this.room_number,
    required this.type,
    required this.beds,
  });

  factory RoomModel.from_entity(Room room) {
    return RoomModel(
      room_id: room.room_id,
      room_number: room.room_number,
      type: room.type.name, 
      beds: room.beds.map((b) => BedModel.fromEntity(b)).toList(),
    );
  }

  Room to_entity() {
    return Room(
      room_id: room_id,
      room_number: room_number,
      number_of_beds: beds.length,
      type: room_type.values.firstWhere(
        (e) => e.name == type,
        orElse: () => room_type.general,
      ),
    )..beds.setAll(0, beds.map((b) => b.toEntity()).toList());
  }

  Map<String, dynamic> to_json() => {
        'room_id': room_id,
        'room_number': room_number,
        'type': type,
        'beds': beds.map((b) => b.to_json()).toList(),
      };

  /// Convert JSON → model
  factory RoomModel.from_json(Map<String, dynamic> json) {
    final bedList =
        (json['beds'] as List).map((b) => BedModel.from_json(b)).toList();

    return RoomModel(
      room_id: json['room_id'],
      room_number: json['room_number'],
      type: json['type'],
      beds: bedList,
    );
  }
}
