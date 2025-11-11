import '../entities/enums.dart';
import '../entities/bed.dart';
import '../entities/patient.dart';
import '../repositories/i_room_repository.dart';

class AllocatePatient {
  final IRoomRepository repository;

  AllocatePatient({required this.repository});

  void call(Patient patient) {
    final rooms = repository.get_all_rooms();
    if (rooms.isEmpty) {
      throw Exception('No rooms available');
    }

    for (var room in rooms) {
      Bed? bed;
      for (var b in room.beds) {
        if (b.status == bed_status.available) {
          bed = b;
          break;
        }
      }

      if (bed != null) {
        bed.assign_patient(patient);
        repository.save_rooms();
        return;
      }
    }

    throw Exception('All beds are occupied');
  }
}
