import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/weather/weather.dart';

void main(){
  group('WeatherEmpty', () { 
    testWidgets('renders correct text and icon', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherError(),
          ),
        )
      );

      expect(find.text('Something Went Wrong'), findsOneWidget);
      expect(find.text('🙈'), findsOneWidget);
    });
  });
}