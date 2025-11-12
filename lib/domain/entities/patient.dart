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
} 
