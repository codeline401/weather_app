import 'package:equatable/equatable.dart';
import 'package:flutter_weather/weather/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' show WeatherRepository;

part 'weather_state.dart';
part 'weather_cubit.g.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async { //uses our repository to try and retrieve a weather object for the given city
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = Weather.fromRepository(await _weatherRepository.getWeather(city));
      final units = state.temperatureUnits;
      final value = units.isFahrenheit ? weather.temperature.value.toFahrenheits() : weather.temperature.value;

      emit(state.copyWith(
        status: WeatherStatus.success,
        temperatureUnits: units,
        weather: weather.copyWith(temperature: Temperature(value: value)),
      )
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async { //retrieves a new weather object using the 
    //the weather repository given the current weather state
    //Si le status n'est pas un success, rien à rafraîchir.
    if (!state.status.isSuccess) return;
    // Si la météo est vide, rien à faire, on quitte directe la méthode refreshWeather
    if (state.weather == Weather.empty) return;

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(state.weather.location)
      );
      final units = state.temperatureUnits;
      final value = units.isFahrenheit 
        ? weather.temperature.value.toFahrenheits()
        : weather.temperature.value;

      emit(state.copyWith(
        status: WeatherStatus.success,
        temperatureUnits: units,
        weather: weather.copyWith(temperature: Temperature(value: value)),
      ));
      } on Exception {
        emit(state);
    }
  }

  void toggleUnits() { // Toggles the state between Celsus and Fahrenheit

    final units = state.temperatureUnits.isFahrenheit
      ? TemperatureUnits.celsus
      : TemperatureUnits.fahrenheit;

    if (!state.status.isSuccess) 
    {
      emit(state.copyWith(temperatureUnits: units));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) 
    {
      final temperature = weather.temperature;
      final value = units.isCelsus
        ? temperature.value.toCelsus()
        : temperature.value.toFahrenheits();
      
      emit(
        state.copyWith(
          temperatureUnits: units,
          weather: weather.copyWith(temperature: Temperature(value: value))
        ),
      );
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) => WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double{
  double toFahrenheits() => (this * 9 / 5) + 32;
  double toCelsus() => (this - 32) * 5 / 9; 
}
