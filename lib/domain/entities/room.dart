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
}
