import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

///Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

///Exception thrown when the provided location is not found
class LocationNotFoundFailure implements Exception {}

///Exception thrown when getWeather fails
class WeatherRequestFailure implements Exception {}

///Exception thrown when weather for the provided locatin is not found
class WeatherNotFOundFailure implements Exception {}

///{@temlpate open_meteo_api_client}
///Dart API Client which wraps the [Open Meteo API](http://open-meteo.com).
///{@endtemlpate}
class OpenMeteoApiClient{
  ///{@macro open_meteo_api_client}
  OpenMeteoApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  final http.Client _httpClient;

  ///Find a [Location] 'v1/search/?name=(query)'
  Future<Location> locationSearch(String query) async {

    //the request api url
    final locationRequest = Uri.https(
      _baseUrlGeocoding, //Url de l'API open-meteo
      'v1/search',
      {'name' : query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if(locationResponse.statusCode != 200)
    {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('result')) throw LocationNotFoundFailure();

    final results = locationJson['result'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    //if there is not any Exception thrown
    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  ///Fetches [Weather] for a given [latitude] and [longitude]
  Future<Weather> getWeather({required double latitude, required double longitude}) async{
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude' : '$latitude',
      'longitude' : '$longitude',
      'current_weather' : 'true',
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if(weatherResponse.statusCode != 200)
    {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if(!bodyJson.containsKey('current_weather')) throw WeatherNotFOundFailure();

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

    //if there is no Exception thrown then
    return Weather.fromJson(weatherJson);
  }
}