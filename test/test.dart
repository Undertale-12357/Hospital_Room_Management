import 'package:test/test.dart';
import 'package:hospital_room_management_system/domain/manage_room.dart';
import 'package:hospital_room_management_system/data/data.dart';

// Dummy Data class that doesn’t actually write/read files
class DummyData extends Data {
  DummyData() : super(filePath: 'dummy.json');

  @override
  void save(List<Room> rooms) {
    // Do nothing (skip file saving)
  }

  @override
  List<Room> load() {
    return []; // No data to load
  }
}

void main() {
  group('ManageRoom', () {
    late ManageRoom hospital;
    late DummyData dummyData;

    setUp(() {
      dummyData = DummyData();
      hospital = ManageRoom(dummyData);
    });

    test('should add a new room successfully', () {
      final room = Room('R101', '101', []);
      hospital.add_room(room);

      expect(hospital.rooms.length, 1);
      expect(hospital.rooms.first.id, 'R101');
    });

    test('should not allocate patient if no rooms exist', () {
      final patient = Patient('P001', 'Alice', 'Flu');
      expect(() => hospital.allocate_patient(patient), throwsA(isA<Exception>()));
    });

    test('should allocate a patient to a bed', () {
      final room = Room('R101', '101', [Bed('B001')]);
      hospital.add_room(room);
      final patient = Patient('P001', 'Alice', 'Flu');

      hospital.allocate_patient(patient);

      expect(hospital.rooms.first.beds.first.is_occupied, true);
      expect(hospital.rooms.first.beds.first.patient?.name, 'Alice');
    });

    test('should not allocate patient if all beds are occupied', () {
      final room = Room('R101', '101', [
        Bed('B001', is_occupied: true, patient: Patient('P001', 'Alice', 'Cold')),
      ]);
      hospital.add_room(room);

      final newPatient = Patient('P002', 'Bob', 'Fever');
      expect(() => hospital.allocate_patient(newPatient), throwsA(isA<Exception>()));
    });

    test('should release a patient\'s bed successfully', () {
      final bed = Bed('B001');
      final room = Room('R101', '101', [bed]);
      hospital.add_room(room);

      final patient = Patient('P001', 'Alice', 'Flu');
      hospital.allocate_patient(patient);
      hospital.unoccupied_bed('R101', 'B001');

      expect(bed.is_occupied, false);
    });

    test('should throw exception if releasing already available bed', () {
      final room = Room('R101', '101', [Bed('B001')]);
      hospital.add_room(room);

      expect(() => hospital.unoccupied_bed('R101', 'B001'), throwsA(isA<Exception>()));
    });
  });
}
