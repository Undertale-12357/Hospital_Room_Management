import 'dart:io';
import 'dart:convert';
import '../domain/manage_room.dart';

class Data {
  final String filePath;

  Data({required this.filePath});

  void save(List<Room> rooms) 
  {
    final file = File(filePath);
    final dir = file.parent;
    if (!dir.existsSync())
    {
      dir.createSync(recursive: true);
    }

    final data = rooms.map((room) => room.to_json()).toList();
    file.writeAsStringSync(jsonEncode(data), flush: true);
  }

  List<Room> load()  // Ai
  {
    final file = File(filePath);
    if (!file.existsSync()) return []; 
    final content = file.readAsStringSync();
    final data = jsonDecode(content) as List;
    return data.map((room) => Room.from_json(room)).toList();
  }
}
