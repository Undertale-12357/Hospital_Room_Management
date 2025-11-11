import '../entities/enums.dart';
import '../repositories/i_room_repository.dart';

class ReleaseBed {
  final IRoomRepository repository;

  ReleaseBed({required this.repository});

  void call(String room_id, int bed_number) {
    final room = repository.get_all_rooms().firstWhere(
      (r) => r.room_id == room_id,
      orElse: () => throw Exception('Room $room_id not found'),
    );

    final bed = room.beds.firstWhere(
      (b) => b.bed_number == bed_number,
      orElse: () => throw Exception('Bed $bed_number not found in room $room_id'),
    );

    if (bed.status == bed_status.available) {
      throw Exception('Bed $bed_number is already available');
    }

    bed.release_bed();
    repository.save_rooms();
  }
}
