import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

//Class for managing the theme color state and persisting it using HydratedCubit
class ThemeCubit extends HydratedCubit<Color> {
  //Default theme color (blue in this case)
  static const defaultColor = Color(0xFF2196F3);
  //COnstructor to initialize the cubit with the default color
  ThemeCubit() : super(defaultColor);

  //Function to update the theme color based on the weather data
  void updateTheme(Weather? weather) {
    //Emit the new color based on the weather
    if (weather != null) emit(weather.toColor);
  }
  
  //override the HydratedCubit to parse a Color object form Json
  @override
  Color fromJson(Map<String, dynamic> json) {
    //Extract the color value as a string from the Json and parse it as an integer
    return Color(int.parse(json['color'] as String));
  }

  //Override the HydratedCubit to serialize a Color object to Json
  @override
  Map<String, dynamic> toJson(Color state) {
    //Convert the color value to a string and return it in a Json format
    return <String, String> {'color': '${state.value}'};
  }
}

extension on Weather {
  Color get toColor{
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.yellow;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.unknown:
        return ThemeCubit.defaultColor;
    }
  }
}