  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_weather/weather/weather.dart';

  class SettingsPage extends StatelessWidget {
    const SettingsPage._(); //Constructeur privé pour éviter l'instanciation de la classe 

    static Route<void> route(WeatherCubit weatherCubit) {
      return MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: weatherCubit, //fournit l'instance de weatherCubit à la page SettingPage 
          child: const SettingsPage._(),
        )
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings'),),
        body: ListView(
          children: <Widget>[
            BlocBuilder<WeatherCubit, WeatherState>(
              buildWhen: (previous, current) =>
              //reconstruit le widget seulement si la témperature a changé
                  previous.temperatureUnits != current.temperatureUnits,
              builder: (context, state) {
                return ListTile(
                  title: const Text('Temperature Units'),
                  isThreeLine: true,
                  subtitle: const Text('Use metric measurements for temperature units'),
                  trailing: Switch(
                    //Valeur du switch basée sur la température actuelle
                    value: state.temperatureUnits.isCelsus, 
                    //Appel de la méthode toggleUnits lorsqu'il y a un changement dans la Switch
                    onChanged: (_) => context.read<WeatherCubit>().toggleUnits(),
                  ),
                );
              }
            )
          ],
        ),
      );
    }
  }