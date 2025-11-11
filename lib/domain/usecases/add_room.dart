import '../entities/room.dart';
import '../repositories/i_room_repository.dart';

class AddRoom {
  final IRoomRepository repository;

  AddRoom({required this.repository});

  void call(Room room) {
    repository.add_room(room);
  }
}
