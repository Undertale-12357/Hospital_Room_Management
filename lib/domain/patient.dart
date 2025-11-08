class Patient {
  final String id;
  String name;
  String illness;

  Patient(this.id, this.name, this.illness);

  Map<String, dynamic> to_json() => {
        'id': id,
        'name': name,
        'illness': illness,
      };

  factory Patient.from_json(Map<String, dynamic> json) =>
      Patient(json['id'], json['name'], json['illness']);
}