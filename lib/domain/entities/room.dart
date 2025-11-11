import 'bed.dart';
import 'enums.dart';

class Room {
  final String room_id;
  String room_number;
  final room_type type;
  final List<Bed> beds;

  Room({
    required this.room_id,
    required this.room_number,
    required int number_of_beds,
    this.type = room_type.general,
  }) : beds = List.generate(number_of_beds, (i) => Bed(bed_number: i + 1));

  Bed get_available_bed() {
    for (var bed in beds) {
      if (bed.is_available) return bed;
    }
    throw Exception('No available beds in room $room_id');
  }

  Map<String, dynamic> to_json() => {
        'room_id': room_id,
        'type': type.name,
        'beds': beds.map((b) => b.to_json()).toList(),
      };

  factory Room.from_json(Map<String, dynamic> json) => Room(
        room_id: json['room_id'],
        room_number: json['room_number'],
        number_of_beds: (json['beds'] as List).length,
        type: room_type.values.firstWhere((e) => e.name == json['type']),
      )..beds.setAll(
          0,
          (json['beds'] as List).map((b) => Bed.from_json(b)).toList(),
        );
}
