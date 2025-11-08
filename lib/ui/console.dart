import 'dart:io';
import '../domain/manage_room.dart';
import '../domain/bed.dart';
import '../domain/patient.dart';
import '../domain/room.dart';

class ConsoleUI {
  final ManageRoom manager;

  ConsoleUI(this.manager);

  void start() {
    print("Welcome to Hospital Room Management System");
    manager.load_data();

    while (true) {
      print("\n=== Main Menu ===");
      print("1. View all rooms");
      print("2. Add new room");
      print("3. Add new patient and allocate");
      print("4. Release bed");
      print("5. Save & Exit");
      
      stdout.write("Choose: ");
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          view_rooms();
          break;
        case '2':
          add_room();
          break;
        case '3':
          add_patient();
          break;
        case '4':
          release_bed();
          break;
        case '5':
          exit_program();
          return;
        default:
          print("Invalid option, try again.");
      }
    }
  }

  void view_rooms() {
    if (manager.rooms.isEmpty) {
      print("No rooms found.");
      return;
    }
    for (Room room in manager.rooms) {
      print("\nRoom ${room.number} (ID: ${room.id})");
      for (Bed bed in room.beds) {
        var status = bed.is_occupied
            ? "Occupied by ${bed.patient!.name}"
            : "Free";
        print("  Bed ${bed.id}: $status");
      }
    }
  }

  void add_room() {
    stdout.write("Enter room ID: ");
    final id = stdin.readLineSync() ?? '';

    stdout.write("Enter room number: ");
    final number = stdin.readLineSync() ?? '';

    stdout.write("Enter number of beds: ");
    final bed_count = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

    if (bed_count <= 0)
    {
      print("Number of beds must be greater than 0.");
      return;
    }

    final beds = List.generate(bed_count, (i) => Bed("B${i + 1}"),);
    final room = Room(id, number, beds);
    manager.add_room(room);
    print("Room $number added with $bed_count beds!");
  }

  void add_patient() {
    if (manager.rooms.isEmpty)
    {
      print("No rooms available! Add a room first.");
      return;
    }
    stdout.write("Enter patient ID: ");
    final id = stdin.readLineSync() ?? '';

    stdout.write("Enter patient name: ");
    final name = stdin.readLineSync()!;

    stdout.write("Enter illness: ");
    final illness = stdin.readLineSync()!;

    try{
      final patient = Patient(id, name, illness);
      manager.allocate_patient(patient);
      print("${patient.name} is allocated successfully");
    }
    catch(e)
    {
      print(e);
    }
  }

  void release_bed() {
    stdout.write("Enter room ID: ");
    final room_id = stdin.readLineSync() ?? '';

    stdout.write("Enter bed ID: ");
    final bed_id = stdin.readLineSync() ?? '';

    try{
      manager.unoccupied_bed(room_id, bed_id);
      print("Bed $bed_id in room $room_id released!");
    }
    catch (e)
    {
      print(e);
    }
  }

  void exit_program()
  {
    manager.save_data();
    print("Data saved!");
  }

}
