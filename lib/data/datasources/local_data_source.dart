import 'dart:io';
import 'dart:convert';
import '../models/room_model.dart';

class LocalDataSource {
  final String file_path;

  LocalDataSource({required this.file_path});

  void save_rooms(List<RoomModel> rooms) {
    final file = File(file_path);
    file.createSync(recursive: true); 
    final json_data = rooms.map((r) => r.to_json()).toList();
    file.writeAsStringSync(jsonEncode(json_data));
  }

  List<RoomModel> load_rooms() {
    final file = File(file_path);
    if (!file.existsSync()) return [];
    final content = file.readAsStringSync();
    final data = jsonDecode(content) as List;
    return data.map((r) => RoomModel.from_json(r)).toList();
  }
}
