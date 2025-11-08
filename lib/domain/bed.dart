import 'patient.dart';

class Bed {
  final String id;
  bool is_occupied;
  Patient? patient;

  Bed(this.id, {this.is_occupied = false, this.patient});

  void assign_patient(Patient assign_p) {
    if (is_occupied) {
      throw Exception("Bed is already occupied.");
    }
    patient = assign_p;
    is_occupied = true;
  }

  void free_bed() {
    patient = null;
    is_occupied = false;
  }

  Map<String, dynamic> to_json() => {
        'id': id,
        'is_occupied': is_occupied,
        'patient': patient?.to_json(),
      };

  factory Bed.from_json(Map<String, dynamic> json) {
    return Bed(
      json['id'],
      is_occupied: json['is_occupied'],
      patient:
          json['patient'] != null ? Patient.from_json(json['patient']) : null,
    );
  }
}