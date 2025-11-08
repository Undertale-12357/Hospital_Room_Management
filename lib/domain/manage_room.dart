import '../data/data.dart';
import 'patient.dart';
import 'bed.dart';
import 'room.dart';
class ManageRoom {
  List<Room> rooms = [];
  final Data data;

  ManageRoom(this.data);

  void add_room(Room room) => rooms.add(room);

  void allocate_patient(Patient patient) {
    if (rooms.isEmpty) {
      throw Exception(
          'Cannot allocate patient: No rooms have been created yet.');
    }

    for (Room room in rooms) {
      for (Bed bed in room.beds) {
        if (!bed.is_occupied) {
          bed.assign_patient(patient);
          data.save(rooms);
          return;
        }
      }
    }
    throw Exception("Cannot allocate patient: All beds are full.");
  }

  void unoccupied_bed(String room_id, String bed_id) {
    final room = rooms.firstWhere(
      (room) => room.id == room_id,
      orElse: () => throw Exception("Room with ID $room_id not found."),
    );

    final bed = room.beds.firstWhere(
      (bed) => bed.id == bed_id,
      orElse: () =>
          throw Exception("Bed with ID $bed_id not found in room $room_id."),
    );

    if (!bed.is_occupied) {
      throw Exception("Bed $bed_id in room $room_id is alraedy available.");
    }

    bed.free_bed();
    data.save(rooms);
  }

  List<Bed> get_available_beds() {
    if (rooms.isEmpty) {
      throw Exception("No rooms available to check for beds.");
    }

    return rooms
        .expand((room) => room.beds.where((bed) => !bed.is_occupied))
        .toList();
  }

  List<Patient> get_patients() {
    if (rooms.isEmpty) {
      throw Exception("No rooms available to check for patients.");
    }

    return rooms
        .expand((room) => room.beds)
        .where((bed) => bed.is_occupied && bed.patient != null)
        .map((bed) => bed.patient!)
        .toList();
  }

  void save_data() => data.save(rooms);
  void load_data() => rooms = data.load();
}
