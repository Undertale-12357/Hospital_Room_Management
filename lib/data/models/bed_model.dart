import '../../domain/entities/bed.dart';
import '../../domain/entities/enums.dart';
import 'patient_model.dart';

class BedModel {
  final int bed_number;
  final String status; 
  final PatientModel? patient;

  BedModel({
    required this.bed_number,
    required this.status,
    this.patient,
  });

  factory BedModel.fromEntity(Bed bed) {
    return BedModel(
      bed_number: bed.bed_number,
      status: bed.status.name,
      patient:
          bed.patient != null ? PatientModel.fromEntity(bed.patient!) : null,
    );
  }

  Bed toEntity() {
    return Bed(
      bed_number: bed_number,
      status: bed_status.values.firstWhere(
        (e) => e.name == status,
        orElse: () => bed_status.available,
      ),
      patient: patient?.toEntity(),
    );
  }

  Map<String, dynamic> to_json() => {
        'bed_number': bed_number,
        'status': status,
        'patient': patient?.to_json(),
      };

  factory BedModel.from_json(Map<String, dynamic> json) {
    return BedModel(
      bed_number: json['bed_number'],
      status: json['status'],
      patient: json['patient'] != null
          ? PatientModel.from_json(json['patient'])
          : null,
    );
  }
}
