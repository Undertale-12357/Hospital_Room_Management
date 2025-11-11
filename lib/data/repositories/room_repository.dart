import '../../domain/entities/room.dart';
import '../../domain/repositories/i_room_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements IRoomRepository {
  final LocalDataSource local_data_source;
  final List<Room> _rooms = [];

  RoomRepositoryImpl({required this.local_data_source});

  @override
  void add_room(Room room) {
    _rooms.add(room);
    save_rooms();
  }

  @override
  Room get_room(String room_id) {
    return _rooms.firstWhere(
      (r) => r.room_id == room_id,
      orElse: () => throw Exception('Room $room_id not found'),
    );
  }

  @override
  List<Room> get_all_rooms() => List.unmodifiable(_rooms);

  @override
  void save_rooms() {
    final models = _rooms.map((r) => RoomModel.from_entity(r)).toList();
    local_data_source.save_rooms(models);
  }

  @override
  void load_rooms() {
    final models = local_data_source.load_rooms();
    _rooms.clear();
    _rooms.addAll(models.map((m) => m.to_entity()));
  }
}
