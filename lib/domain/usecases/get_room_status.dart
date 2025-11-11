import '../entities/room.dart';
import '../repositories/i_room_repository.dart';

class GetRoomStatus {
  final IRoomRepository repository;

  GetRoomStatus({required this.repository});

  List<Room> call() {
    return repository.get_all_rooms();
  }
}
