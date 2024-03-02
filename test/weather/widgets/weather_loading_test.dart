import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/weather/weather.dart';

void main() {
  group('WeatherLoading', () { 
    testWidgets('renders correct text and icon', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherLoading(),
          ),
        )
      );

      expect(find.text('Loading Weather'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('⛅'), findsOneWidget);
    });
  });
}