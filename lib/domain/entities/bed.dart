import 'enums.dart';
import 'patient.dart';

class Bed {
  final int bed_number;
  bed_status status;
  Patient? patient;

  Bed({
    required this.bed_number,
    this.status = bed_status.available,
    this.patient,
  });

  bool get is_available => status == bed_status.available;

  void assign_patient(Patient new_patient) {
    if (!is_available) throw Exception('Bed already occupied');
    patient = new_patient;
    status = bed_status.occupied;
  }

  void release_bed() {
    if (is_available) throw Exception('Bed is already available');
    patient = null;
    status = bed_status.available;
  }
}
