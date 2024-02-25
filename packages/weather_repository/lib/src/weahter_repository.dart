import 'dart:async';

//Pour récupérer des données météorologiques avec l'API open Météo
import 'package:open_meteo_api/open_meteo_api.dart' hide Weather;

import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {

  //Constructeur, il prend en option un OpenMeteoApiCLient
  //s'il n'est pas fourni, il crée une instance par défaut OpenMeteoApiClient
  WeatherRepository({OpenMeteoApiClient? weatherApiClient})
    : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient();

    //variable stockant l'instance du client API à utiliser pour les requêtes
    final _weatherApiClient;

    Future<Weather> getWeather(String city) async {
      //récupère les coordonnées de la ville city
      final location = await _weatherApiClient.locationSearch(city);
      //récupère les données météoroliques pour ces coordonnées 
      final weather = await _weatherApiClient.getWeather(
        latitude : location.latitude,
        longitude : location.longitude
      );

      return Weather(                                           //crée et retourne un objet Weather avec les données récupérées
        location:     location.name,                          
        temperature:  weather.temperature, 
        condition:    weather.weatherCode.toInt().toCondition, //déterminé à partir du code météo de l'API en utilisant l'extension toCondition
        );
    }
}

extension on int {
  WeatherCondition get toCondition{
    switch (this) {
      case 0 :
        return WeatherCondition.clear;
      case 1 :
      case 2 :
      case 3 :
      case 45 :
      case 48 :
        return WeatherCondition.cloudy;
      case 51 :
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default :
        return WeatherCondition.unknown;
    }
  }
}