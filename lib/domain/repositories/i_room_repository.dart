import '../entities/room.dart';

abstract class IRoomRepository {
  void add_room(Room room);
  Room get_room(String room_id);
  List<Room> get_all_rooms();
  void save_rooms();
  void load_rooms();
}
