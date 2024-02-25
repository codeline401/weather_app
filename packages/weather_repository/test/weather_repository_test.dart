import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

//Création de classe Mock pour OpenMateoApiClient, Location et Weather
class MockOpenMeteoApiClient extends Mock implements open_meteo_api.OpenMeteoApiClient {}
class MockLocation extends Mock implements open_meteo_api.Location {}
class MockWeather extends Mock implements open_meteo_api.Weather {}

void main () {

  //Groupe de test pour l'entité WeatherRepository
  group('WeatherRepository', () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() { //Méthode appelée avant chaque groupe de test ou test
      weatherApiClient = MockOpenMeteoApiClient();
      weatherRepository = WeatherRepository(weatherApiClient: weatherApiClient);
    });

    //sous-groupe de test pour le constructeur
    group('constructor', () {
      //test pour vérifier si WeatherRepository n'est pas nulle
      test('instantiates internal weather api client when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    //sous-groupe de test pour la méthode getWheather
    group('getWeahter', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('calls locationSearch with correct city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => weatherApiClient.locationSearch(city)).called(1);
      });

      test('throws when locatioSearch fails', () async {
        final exception = Exception('oops');
        //Simulons une erreur dans locationSerach
        when(() => weatherApiClient.locationSearch(any())).thenThrow(exception);

        //Vérifions que getWeather lance l'exception
        expect(
          () async => weatherRepository.getWeather(city), 
          throwsA(exception)
        );
      });

      test('calls getWeahter with correct latitude/longitude', () async{
        final location = MockLocation();

        when(() => location.latitude).thenReturn(latitude as String);
        when(() => location.longitude).thenReturn(longitude as String);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location);

        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}

        verify(
          () => weatherApiClient.getWeather(latitude: latitude, longitude: longitude)
        ).called(1);
      });

      test('throws when getWeather fails', () async {
        // **Simule une exception dans getWeether**
        final exception = Exception('oops'); //Crée une exception personnalisée
        final location = MockLocation(); //Crée un Mock pur la Location

        // **Simule la réussite de locationSearch**
        when(() => location.latitude).thenReturn(latitude as String); //fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); //fixe la longitude simulée
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); //Simule le succès de locationSearch

        // **Simule une exception dans weatherApiCLient.getWeather**
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), //accpete n'importe quelle valeur de latitude
          longitude: any(named: 'longitude')) //accepte n'importe quelle valeur pour longitude
        ).thenThrow(exception); //simule l'echec de getWeather

        // **Vérifie quee à l'appel à getWeather lève l'exception attendue**
        expect(
          () async => weatherRepository.getWeather(city), throwsA(exception));
      });

      test('returns correct weather on success (clear)', () async {
        // **Simule des données météo de test**
        final location = MockLocation(); //crée un mock de location
        final weather = MockWeather(); //crée un mock de Weather

        when(() => location.name).thenReturn(city); //fixe le nom de la ville simulée
        when(() => location.latitude).thenReturn(latitude as String); //fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); //fixe la longitude simulée
        when(() => weather.temperature).thenReturn(42.42); //fixe la température simulée
        when(() => weather.weatherCode).thenReturn(0); //fixe le code météo (0 correspond à clear)

        // **Simule le succès de locationSearch et getWeather**
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); //Simule le succès de locationSearch
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), // Accepte n'importe quelle valeur de latitude
          longitude: any(named: 'longitude'), // Accepte n'importe quelle valeur de longitude
          ),
        ).thenAnswer((_) async => weather); // Simile le succès de getWeather

        // **Appelle getWeather et vérifie le résultat
        final actual = await weatherRepository.getWeather(city); //appelle la méthode
        expect(
          actual, 
          Weather( //Vérifie quele résultat correspond à l'attendu
            location: city, //nom de la ville 
            temperature: 42.42, // température
            condition: WeatherCondition.clear)); // condition météo
      });

      test('returns correct weather on success (cloudy)', () async {
        // **Simule des données météo de test**
        final location = MockLocation(); //crée un Mock de Location
        final weatheer = MockWeather(); // crée un Mock de weather

        when(() => location.name).thenReturn(city); //fixe le nom de la ville simulée
        when(() => location.latitude).thenReturn(latitude as String); // fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); // fixe la lognitude simulée
        when(() => weatheer.temperature).thenReturn(42.42); // fixe la température simulée
        when(() => weatheer.weatherCode).thenReturn(1);

        //** Simule le succès de locationSearch et getWeather */
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); // simule le succès de locationSearch
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), 
          longitude: any(named: 'longitude'))).thenAnswer((_) async => weatheer); // sumile le succès de getWeather

        // **Appelle getWeather et vérifié le resultat**
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual, 
          Weather( //Vérifie que le résultat correspond à l'attendu
            location: city, // nom de la ville
            temperature: 42.42, //température
            condition: WeatherCondition.cloudy)); //condition météo
      });

      test('returns correct weather on success (rainy)', () async {
        // **Simule des données météo de test**
        final location = MockLocation(); //crée un Mock de Location
        final weatheer = MockWeather(); // crée un Mock de weather

        when(() => location.name).thenReturn(city); //fixe le nom de la ville simulée
        when(() => location.latitude).thenReturn(latitude as String); // fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); // fixe la lognitude simulée
        when(() => weatheer.temperature).thenReturn(42.42); // fixe la température simulée
        when(() => weatheer.weatherCode).thenReturn(51);

        //** Simule le succès de locationSearch et getWeather */
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); // simule le succès de locationSearch
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), 
          longitude: any(named: 'longitude'))).thenAnswer((_) async => weatheer); // sumile le succès de getWeather

        // **Appelle getWeather et vérifié le resultat**
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual, 
          Weather( //Vérifie que le résultat correspond à l'attendu
            location: city, // nom de la ville
            temperature: 42.42, //température
            condition: WeatherCondition.rainy)); //condition météo
      });

      test('returns correct weather on success (snowy)', () async {
        // **Simule des données météo de test**
        final location = MockLocation(); //crée un Mock de Location
        final weatheer = MockWeather(); // crée un Mock de weather

        when(() => location.name).thenReturn(city); //fixe le nom de la ville simulée
        when(() => location.latitude).thenReturn(latitude as String); // fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); // fixe la lognitude simulée
        when(() => weatheer.temperature).thenReturn(42.42); // fixe la température simulée
        when(() => weatheer.weatherCode).thenReturn(71);

        //** Simule le succès de locationSearch et getWeather */
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); // simule le succès de locationSearch
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), 
          longitude: any(named: 'longitude'))).thenAnswer((_) async => weatheer); // sumile le succès de getWeather

        // **Appelle getWeather et vérifié le resultat**
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual, 
          Weather( //Vérifie que le résultat correspond à l'attendu
            location: city, // nom de la ville
            temperature: 42.42, //température
            condition: WeatherCondition.snowy)); //condition météo
      });

      test('returns correct weather on success (unknown)', () async {
        // **Simule des données météo de test**
        final location = MockLocation(); //crée un Mock de Location
        final weatheer = MockWeather(); // crée un Mock de weather

        when(() => location.name).thenReturn(city); //fixe le nom de la ville simulée
        when(() => location.latitude).thenReturn(latitude as String); // fixe la latitude simulée
        when(() => location.longitude).thenReturn(longitude as String); // fixe la lognitude simulée
        when(() => weatheer.temperature).thenReturn(42.42); // fixe la température simulée
        when(() => weatheer.weatherCode).thenReturn(-1);

        //** Simule le succès de locationSearch et getWeather */
        when(() => weatherApiClient.locationSearch(any())).thenAnswer((_) async => location); // simule le succès de locationSearch
        when(() => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'), 
          longitude: any(named: 'longitude'))).thenAnswer((_) async => weatheer); // sumile le succès de getWeather

        // **Appelle getWeather et vérifié le resultat**
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual, 
          Weather( //Vérifie que le résultat correspond à l'attendu
            location: city, // nom de la ville
            temperature: 42.42, //température
            condition: WeatherCondition.unknown)); //condition météo
      });
    });
  });
}