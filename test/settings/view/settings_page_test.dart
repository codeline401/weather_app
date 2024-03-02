import  'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/settings/setting.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:mocktail/mocktail.dart';


class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {}

void main() {
  group('SettingsPage', () { 

    late WeatherCubit weatherCubit;

    setUp(() {
      weatherCubit = MockWeatherCubit();
    });

    testWidgets('is routable', (widgetTester) async {
      //simule l'état initial pour WeatherCubit
      when(() => weatherCubit.state).thenReturn(WeatherState());
      //Création et rendue de l'interface utilisateur avec MaterialApp
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(SettingsPage.route(weatherCubit));
                }
              ),
            )
          ),
        )
      );
      //Appui sur le boutton FloatingActionButton
      await widgetTester.tap(find.byType(FloatingActionButton));
      //Attend que les animations se terminent et que l'interface soit stable
      await widgetTester.pumpAndSettle();
      //Vérifie si la page de paramètre est présente
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('calls toggleUnits when switch is changed', (widgetTester) async {
      whenListen(
        weatherCubit, 
        Stream.fromIterable([
          WeatherState(),
          WeatherState(temperatureUnits: TemperatureUnits.fahrenheit)
        ])
      );

      when(() => weatherCubit.state).thenReturn(WeatherState());

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(SettingsPage.route(weatherCubit));
                }
              ),
            )
          ),
        )
      );

      await widgetTester.tap(find.byType(FloatingActionButton));
      //Attend que les animations se terminent et que l'interface soit stable
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(Switch));
      //Vérifie que la méthode toggleUnits a été appelé une et une seule fois.
      verify(() => weatherCubit.toggleUnits()).called(1);
    });
  });
}