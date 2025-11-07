import 'ui/console.dart';
import 'domain/manage_room.dart';
import 'data/data.dart';

void main() {
  final data = Data(filePath: 'lib/data/room_data.json');
  final manager = ManageRoom(data);
  final console = ConsoleUI(manager);
  
  manager.load_data();
  
  console.start();

  manager.save_data();
}
