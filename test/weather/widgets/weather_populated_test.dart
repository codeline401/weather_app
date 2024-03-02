import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/weather/weather.dart';

void main() {
  group('WeatherPopulated', () { 
    final weather = Weather(
      condition: WeatherCondition.clear, 
      lastUpdated: DateTime(2020), 
      location: 'Chicago', 
      temperature: const Temperature(value: 20)
    );

    testWidgets('renders correct emoji (clear)', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body : WeatherPopulated(
              weather: weather,
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            )
          ),
        )
      );

      expect(find.text('☀️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (rainy)', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.rainy), 
              units: TemperatureUnits.fahrenheit, 
              onRefresh: () async {},
            ),
          ),
        )
      );

      expect(find.text('🌧️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (cloudy)', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.cloudy), 
              units: TemperatureUnits.fahrenheit, 
              onRefresh: () async {}
            ),
          ),
        )
      );

      expect(find.text('☁️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (snowy)', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.snowy), 
              units: TemperatureUnits.fahrenheit, 
              onRefresh: () async {}
            ),
          ),
        )
      );

      expect(find.text('🌨️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (unknown)', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.unknown), 
              units: TemperatureUnits.fahrenheit, 
              onRefresh: () async {}
            ),
          ),
        )
      );

      expect(find.text('❓'), findsOneWidget);
    });
  });
}