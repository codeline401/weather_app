import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group('Weather', () { //Groupe de test pour la classe Weather
    group('fromJson', () { //sous-groupe de test pour la methode formJson
      test('returns correct Weather object', () {
        expect(Weather.fromJson(
          <String, dynamic>{'temperature': 15.3, 'weathercode' : 63}
        ),
        isA<Weather>()
          .having((w) => w.temperature, 'temperature', 15.3)
          .having((w) => w.weatherCode, 'weatherCode', 63)
        );
      });
    });
  });
}