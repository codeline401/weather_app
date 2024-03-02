import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/theme/theme.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import 'helpers/hydrated_bloc.dart';

class MockThemeCubit extends MockCubit<Color> implements ThemeCubit {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  initHydratedStorage();

  group('weatherApp', () { 
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherAppView', (widgetTester) async {
      await widgetTester.pumpWidget(
        WeatherApp(weatherRepository: weatherRepository)
      );

      expect(find.byType(WeatherAppView), findsOneWidget);
    });
  });

  group('WeatherAppView', () { 
    late ThemeCubit themeCubit;
    late WeatherRepository weatherRepository;

    setUp(() {
      themeCubit = MockThemeCubit();
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherPage', (widgetTester) async {
      when(() => themeCubit.state).thenReturn(Colors.blue);

      await widgetTester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: BlocProvider.value(
             value: themeCubit,
             child: const WeatherAppView(),
          ),
        ),
      );

      expect(find.byType(WeatherPage), findsOneWidget);
    });

    testWidgets('has correct theme color scheme', (widgetTester) async {
      const color = Color(0xFFD2D2D2);
      when(() => themeCubit.state).thenReturn(color);

      await widgetTester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: BlocProvider.value(
            value: themeCubit,
            child: const WeatherAppView(),
          ),
        )
      );

      final materialApp = widgetTester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme, ColorScheme.fromSeed(seedColor: color));
    });
  });
}