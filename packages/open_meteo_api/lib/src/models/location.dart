import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  //constructor
  const Location({required this.id, required this.name, required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => 
    _$LocationFromJson(json);

  //Proprieties
  final String id;
  final String name;
  final String latitude;
  final String longitude;
}