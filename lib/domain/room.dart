import 'bed.dart';

class Room {
  final String id;
  String number;
  List<Bed> beds;

  Room(this.id, this.number, this.beds);

  int count_available_beds() {
    return beds.where((bed) => !bed.is_occupied).length; // AI fix syntax
  }

  void add_bed(Bed bed) => beds.add(bed);

  Bed find_available_bed() => beds.firstWhere((bed) => !bed.is_occupied,
      orElse: () => throw Exception("No available beds in room $number."));

  Map<String, dynamic> to_json() => {
        'id': id,
        'number': number,
        'beds': beds.map((bed) => bed.to_json()).toList(),
      };

  factory Room.from_json(Map<String, dynamic> json) {
    var bed_list =
        (json['beds'] as List).map((bed) => Bed.from_json(bed)).toList();
    return Room(json['id'], json['number'], bed_list);
  }
}
