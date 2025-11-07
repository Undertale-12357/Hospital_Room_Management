import '../data/data.dart';

class Patient 
{
  final String id;
  String name;
  String illness;

  Patient(this.id, this.name, this.illness);

  
  Map<String, dynamic> to_json() => 
  {
    'id': id,
    'name': name,
    'illness': illness,
  };

  factory Patient.from_json(Map<String, dynamic> json) =>
    Patient(json['id'], json['name'], json['illness']);
}

class Bed
{
  final String id;
  bool is_occupied;
  Patient? patient;

  Bed(this.id, {this.is_occupied = false, this.patient});

  void assign_patient(Patient assign_p)
  {
    if (is_occupied)
    {
      throw Exception("Bed is already occupied.");
    }
    patient = assign_p;
    is_occupied = true;
  }

  void free_bed()
  {
    patient = null;
    is_occupied = false;
  }

  Map<String, dynamic> to_json() => 
  {
    'id': id,
    'is_occupied': is_occupied,
    'patient': patient?.to_json(),
  };

  factory Bed.from_json(Map<String, dynamic> json) 
  {
    return Bed(
      json['id'],
      is_occupied: json['is_occupied'],
      patient: json['patient'] != null ? Patient.from_json(json['patient']) : null,
    );
  }
}

class Room
{
  final String id;
  String number;
  List<Bed> beds;

  Room(this.id, this.number, this.beds);

  int count_available_beds()
  {
    return beds.where((bed) => !bed.is_occupied).length; // AI fix syntax
  }

  void add_bed(Bed bed) => beds.add(bed);

  Bed find_available_bed() => beds.firstWhere
  (
    (bed) => !bed.is_occupied,
    orElse: () => throw Exception("No available beds in room $number.")
  );

  Map<String, dynamic> to_json() => 
  {
    'id': id,
    'number': number,
    'beds': beds.map((bed) => bed.to_json()).toList(),
  };

  factory Room.from_json(Map<String, dynamic> json) 
  {
    var bed_list = (json['beds'] as List).map((bed) => Bed.from_json(bed)).toList();
    return Room(json['id'], json['number'], bed_list);
  }
}

class ManageRoom
{
  List<Room> rooms = [];
  final Data data;

  ManageRoom(this.data);

  void add_room(Room room) => rooms.add(room);

  void allocate_patient (Patient patient)
  {
    if (rooms.isEmpty)
    {
      throw Exception('Cannot allocate patient: No rooms have been created yet.');
    }

    for (Room room in rooms)
    {
      for (Bed bed in room.beds)
      {
        if(!bed.is_occupied)
        {
          bed.assign_patient(patient);
          data.save(rooms);
          return;
        }
      }
    }
    throw Exception("Cannot allocate patient: All beds are full.");
  }

  void unoccupied_bed(String room_id, String bed_id)
  {
    final room = rooms.firstWhere(
      (room) => room.id == room_id,
      orElse: () => throw Exception("Room with ID $room_id not found."),
    );

    final bed = room.beds.firstWhere(
      (bed) => bed.id == bed_id,
      orElse: () => throw Exception("Bed with ID $bed_id not found in room $room_id."),
    );

    if (!bed.is_occupied)
    {
      throw Exception("Bed $bed_id in room $room_id is alraedy available.");
    }

    bed.free_bed();
    data.save(rooms);
  }

  List<Bed> get_available_beds()
  {
    if (rooms.isEmpty)
    {
      throw Exception("No rooms available to check for beds.");
    }

    return rooms.expand((room) => room.beds.where((bed) => !bed.is_occupied)).toList();
  }

  List<Patient> get_patients()
  {
    if (rooms.isEmpty)
    {
      throw Exception("No rooms available to check for patients.");
    }

    return rooms
          .expand((room) => room.beds)
          .where((bed) => bed.is_occupied && bed.patient != null)
          .map((bed) => bed.patient!).toList();
  }

  void save_data() => data.save(rooms);
  void load_data() => rooms = data.load();
}

