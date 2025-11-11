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

  Map<String, dynamic> to_json() => {
        'bed_number': bed_number,
        'status': status.name,
        'patient': patient?.to_json(),
      };

  factory Bed.from_json(Map<String, dynamic> json) => Bed(
        bed_number: json['bed_number'],
        status: bed_status.values.firstWhere((e) => e.name == json['status']),
        patient: json['patient'] != null
            ? Patient.from_json(json['patient'])
            : null,
      );
}
