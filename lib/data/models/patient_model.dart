import '../../domain/entities/patient.dart';
import '../../domain/entities/enums.dart';

class PatientModel {
  final String patient_id;
  final String name;
  final String condition;

  PatientModel({
    required this.patient_id,
    required this.name,
    required this.condition,
  });

  factory PatientModel.fromEntity(Patient patient) => PatientModel(
        patient_id: patient.patient_id,
        name: patient.name,
        condition: patient.condition.name,
      );

  Patient toEntity() => Patient(
        patient_id: patient_id,
        name: name,
        condition: patient_condition.values.firstWhere(
            (e) => e.name == condition,
            orElse: () => patient_condition.stable),
      );

  Map<String, dynamic> to_json() => {
        'patient_id': patient_id,
        'name': name,
        'condition': condition,
      };

  factory PatientModel.from_json(Map<String, dynamic> json) => PatientModel(
        patient_id: json['patient_id'],
        name: json['name'],
        condition: json['condition'],
      );
}
