// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Character {
  final String id;
  final String gender;
  final String location;
  final String type;
  final String species;
  final String image;
  final String name;
  final String status;
  Character({
    required this.id,
    required this.gender,
    required this.location,
    required this.type,
    required this.species,
    required this.image,
    required this.name,
    required this.status,
  });

  Character copyWith({
    String? id,
    String? gender,
    String? location,
    String? type,
    String? species,
    String? image,
    String? name,
    String? status,
  }) {
    return Character(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      type: type ?? this.type,
      species: species ?? this.species,
      image: image ?? this.image,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gender': gender,
      'location': location,
      'type': type,
      'species': species,
      'image': image,
      'name': name,
      'status': status,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as String,
      gender: map['gender'] as String,
      location: map['location']['name'] as String,
      type: map['type'] as String,
      species: map['species'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Character(id: $id, gender: $gender, location: $location, type: $type, species: $species, image: $image, name: $name, status: $status)';
  }

  @override
  bool operator ==(covariant Character other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.gender == gender &&
        other.location == location &&
        other.type == type &&
        other.species == species &&
        other.image == image &&
        other.name == name &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        gender.hashCode ^
        location.hashCode ^
        type.hashCode ^
        species.hashCode ^
        image.hashCode ^
        name.hashCode ^
        status.hashCode;
  }
}
