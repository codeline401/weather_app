import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition{
  clear,
  rainy,
  cloudy,
  snowy,
  unknown
}

@JsonSerializable() //la classe Weather peut être sérialisée en JSON et désérialisée à partir de JSON
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => 
    _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final String location;
  final double temperature;
  final WeatherCondition condition;

//surcharge de la fonction props de l'interface Equatable pour comparer les objets Weather
//elle retourne une liste des propriétés de l'objet qui doivent être utilisés pour comparer les objets Weather
  @override
  List<Object> get props => [location, temperature, condition];
}