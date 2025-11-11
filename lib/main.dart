import 'presentation/console_ui.dart';
import 'data/datasources/local_data_source.dart';
import 'data/repositories/room_repository.dart';
import 'domain/usecases/add_room.dart';
import 'domain/usecases/allocate_patient.dart';
import 'domain/usecases/release_bed.dart';
import 'domain/usecases/get_room_status.dart';

void main() {
  final data_source = LocalDataSource(file_path: 'data/room_data.json');
  final room_repository = RoomRepositoryImpl(local_data_source: data_source);

  final add_room_use_case = AddRoom(repository: room_repository);
  final allocate_patient_use_case = AllocatePatient(repository: room_repository);
  final release_bed_use_case = ReleaseBed(repository: room_repository);
  final get_room_status_use_case = GetRoomStatus(repository: room_repository);

  final consoleUI = ConsoleUI(
    add_room_use_case: add_room_use_case,
    allocate_patient_use_case: allocate_patient_use_case,
    release_bed_use_case: release_bed_use_case,
    get_room_status_use_case: get_room_status_use_case,
  );

  consoleUI.start();
}
