import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import '../lib/domain/entities/room.dart';
import '../lib/domain/entities/bed.dart';
import '../lib/domain/entities/patient.dart';
import '../lib/domain/entities/enums.dart';
import '../lib/domain/repositories/i_room_repository.dart';
import '../lib/domain/usecases/add_room.dart';
import '../lib/domain/usecases/allocate_patient.dart';
import '../lib/domain/usecases/get_room_status.dart';
import '../lib/domain/usecases/release_bed.dart';

// Mock repository
class MockRoomRepository extends Mock implements IRoomRepository {}

void main() {
  late MockRoomRepository repository;
  late AddRoom addRoom;
  late AllocatePatient allocatePatient;
  late GetRoomStatus getRoomStatus;
  late ReleaseBed releaseBed;

  setUp(() {
    repository = MockRoomRepository();
    addRoom = AddRoom(repository: repository);
    allocatePatient = AllocatePatient(repository: repository);
    getRoomStatus = GetRoomStatus(repository: repository);
    releaseBed = ReleaseBed(repository: repository);
  });

  group('AddRoom UseCase', () {
    test('should call repository to add room', () {
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 2);

      addRoom(room);

      verify(() => repository.add_room(room)).called(1);
    });
  });

  group('AllocatePatient UseCase', () {
    test('should throw exception if no rooms', () {
      when(() => repository.get_all_rooms()).thenReturn([]);

      final patient = Patient(patient_id: 'P1', name: 'Alice');
      expect(() => allocatePatient(patient), throwsA(isA<Exception>()));
    });

    test('should assign patient to first available bed', () {
      final bed1 = Bed(bed_number: 1);
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 1);
      room.beds[0] = bed1;

      when(() => repository.get_all_rooms()).thenReturn([room]);
      when(() => repository.save_rooms()).thenReturn(null);

      final patient = Patient(patient_id: 'P1', name: 'Alice');
      allocatePatient(patient);

      expect(bed1.status, bed_status.occupied);
      expect(bed1.patient, patient);
      verify(() => repository.save_rooms()).called(1);
    });

    test('should throw exception if all beds occupied', () {
      final bed1 = Bed(bed_number: 1, status: bed_status.occupied);
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 1);
      room.beds[0] = bed1;

      when(() => repository.get_all_rooms()).thenReturn([room]);

      final patient = Patient(patient_id: 'P1', name: 'Alice');
      expect(() => allocatePatient(patient), throwsA(isA<Exception>()));
    });
  });

  group('GetRoomStatus UseCase', () {
    test('should return rooms from repository', () {
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 1);
      when(() => repository.get_all_rooms()).thenReturn([room]);

      final result = getRoomStatus();

      expect(result, [room]);
    });
  });

  group('ReleaseBed UseCase', () {
    test('should release bed successfully', () {
      final bed1 = Bed(bed_number: 1, status: bed_status.occupied, patient: Patient(patient_id: 'P1', name: 'Alice'));
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 1);
      room.beds[0] = bed1;

      when(() => repository.get_all_rooms()).thenReturn([room]);
      when(() => repository.save_rooms()).thenReturn(null);

      releaseBed.call('R1', 1);

      expect(bed1.status, bed_status.available);
      expect(bed1.patient, null);
      verify(() => repository.save_rooms()).called(1);
    });

    test('should throw exception if bed already available', () {
      final bed1 = Bed(bed_number: 1);
      final room = Room(room_id: 'R1', room_number: '101', number_of_beds: 1);
      room.beds[0] = bed1;

      when(() => repository.get_all_rooms()).thenReturn([room]);

      expect(() => releaseBed.call('R1', 1), throwsA(isA<Exception>()));
    });
  });
}
