import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' as weather_repository;

import '../../helpers/hydrated_bloc.dart';

const weatherLocation ='London';
const weatherCondition = weather_repository.WeatherCondition.rainy;
const weatherTemperature = 9.8;

class MockWeatherRepositiry extends Mock implements weather_repository.WeatherRepository{}

