import 'dart:io';
import '../domain/entities/enums.dart';
import '../domain/entities/room.dart';
import '../domain/entities/patient.dart';
import '../domain/usecases/add_room.dart';
import '../domain/usecases/allocate_patient.dart';
import '../domain/usecases/release_bed.dart';
import '../domain/usecases/get_room_status.dart';

class ConsoleUI {
  final AddRoom add_room_use_case;
  final AllocatePatient allocate_patient_use_case;
  final ReleaseBed release_bed_use_case;
  final GetRoomStatus get_room_status_use_case;

  ConsoleUI({
    required this.add_room_use_case,
    required this.allocate_patient_use_case,
    required this.release_bed_use_case,
    required this.get_room_status_use_case,
  });

  void start() {
    while (true) {
      print('\n===== Hospital Room Management =====');
      print('1. Add Room');
      print('2. Allocate Patient');
      print('3. Release Bed');
      print('4. Show Room Status');
      print('5. Exit');
      stdout.write('Choose an option: ');
      final input = stdin.readLineSync();

      switch (input) {
        case '1':
          _addRoom();
          break;
        case '2':
          _allocatePatient();
          break;
        case '3':
          _releaseBed();
          break;
        case '4':
          _showRoomStatus();
          break;
        case '5':
          print('Exiting...');
          return;
        default:
          print('Invalid option. Try again.');
      }
    }
  }

  void _addRoom() {
    try {
      stdout.write('Enter room ID: ');
      final id = stdin.readLineSync()!;
      stdout.write('Enter room number: ');
      final number = stdin.readLineSync()!;
      stdout.write('Enter number of beds: ');
      final bed_count = int.parse(stdin.readLineSync()!);

      print('\nSelect room type:');
      print('1. General');
      print('2. ICU');
      print('3. VIP');
      stdout.write('Enter choice (1-3): ');
      final choice = stdin.readLineSync()!;

      room_type selected_type;
      switch (choice) {
        case '1':
          selected_type = room_type.general;
          break;
        case '2':
          selected_type = room_type.icu;
          break;
        case '3':
          selected_type = room_type.private;
          break;
        default:
          throw Exception('Invalid room type selection.');
      }
      final room = Room(
        room_id: id,
        number_of_beds: bed_count, 
        room_number: number,
        type: selected_type,   
      );

      add_room_use_case(room);
      print('Room $number added successfully with $bed_count beds.');
    } catch (e) {
      print('Error adding room: $e');
    }
  }

  void _allocatePatient() {
    try {
      stdout.write('Enter patient ID: ');
      final id = stdin.readLineSync()!;
      stdout.write('Enter patient name: ');
      final name = stdin.readLineSync()!;
       print('Select patient condition:');
    for (var c in patient_condition.values) {
      print('${c.index + 1}. ${c.name}');
    }
    stdout.write('Enter choice number: ');
    final choice = int.tryParse(stdin.readLineSync()!) ?? 1;
    final condition = patient_condition.values[choice - 1];

    final patient = Patient(patient_id: id, name: name, condition: condition);

    allocate_patient_use_case(patient);

      print('Patient $name allocated successfully.');
    } catch (e) {
      print('Error allocating patient: $e');
    }
  }

  void _releaseBed() {
    try {
      stdout.write('Enter room ID: ');
      final roomId = stdin.readLineSync()!;
      stdout.write('Enter bed number: ');
      final bed_number_int = stdin.readLineSync()!;
      final bed_number = int.tryParse(bed_number_int);

      if(bed_number == null)
      {
        print('Invalid bed number. Please enter a valid integer.');
        return;
      }

      release_bed_use_case(roomId, bed_number);
      print('Bed $bed_number in room $roomId released successfully.');
    } catch (e) {
      print('Error releasing bed: $e');
    }
  }

  void _showRoomStatus() {
    final rooms = get_room_status_use_case();
    for (var room in rooms) {
      print('Room: ${room.room_number} (ID: ${room.room_id})');
      for (var bed in room.beds) {
        final status = bed.status == bed_status.available ? 'Available' : 'Occupied';
        final patientName = bed.patient?.name ?? '';
        print('  Bed ${bed.bed_number}: $status ${patientName.isNotEmpty ? "- $patientName" : ""}');
      }
    }
  }
}
