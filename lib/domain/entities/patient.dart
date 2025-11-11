import 'enums.dart';

class Patient {
  final String patient_id;
  final String name;
  final patient_condition condition;

  Patient({
    required this.patient_id,
    required this.name,
    this.condition = patient_condition.stable,
  });

  Map<String, dynamic> to_json() => {
        'patient_id': patient_id,
        'name': name,
        'condition': condition.name,
      };

  factory Patient.from_json(Map<String, dynamic> json) => Patient(
        patient_id: json['patient_id'],
        name: json['name'],
        condition: patient_condition.values
            .firstWhere((e) => e.name == json['condition']),
      );
}
