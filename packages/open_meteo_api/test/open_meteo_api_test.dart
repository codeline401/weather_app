//Notre objectif ici est de tester la logique du client API et non l'API elle-même
//Afin d'avoir un environnement de test cohérent et controllé,
//nous utiliserons Mocktail pour simuler le client http

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

//Pour simuler le comportement d'un client HTTP dans un environnement contrôllé
class MockHttpCLient extends Mock implements http.Client {}

//Pour simuler les réponses d'un client HTTP dans un environnement contrôllé
class MockResponse extends Mock implements http.Response {}

//Pour simuler des objet Uri dans un environnement contrôllé
//Lezs objet Uri sont utilsés pour représente les adresses URL et les identifiants uniformes
class FakeUri extends Fake implements Uri {}

void main() {
  //Définition d'un groupe de tests pour la classe OpenMeteoApiClient
  group('OpenMeteoApiClient', () {
    late http.Client httpClient;
    late OpenMeteoApiClient apiClient;

    //Méthode appelée avant tous les tests du groupe
    setUpAll(() {
      //Enregistrement de la valeur de remplacement pour l'URI simulé
      //assurera que cette valeur est disponible pour tous les tests du groupe
      registerFallbackValue(FakeUri());
    });

    //Methode appeléé avant chaque test du groupe
    setUp(() {
      //Initialisation du client HTTP mock
      httpClient = MockHttpCLient();
      //Initialisation de l'API client avec le client HTTP mock
      apiClient = OpenMeteoApiClient(httpClient: httpClient);
    });

    //Définition d'un groupe de tests pour le constructeur de la classe OpenMeteoApiClient
    group('constructor', () {
      //test pour vérifier que le constructeur fonctionne même sans httpClient
      test('does not require an httpClient', () {
        //Vérification que l'API client est non nulle
        expect(OpenMeteoApiClient(), isNotNull);
      });
    });

    //Définition d'un groupe de tests pour la méthode locationSearch de la classe OpenMeteoApiClient
    group('locationSearch', () {
      //Définition d'une constante pour la requette de recherche
      const query = 'mock-query';

      //Test pour vérifier que la requête HTTP est correctement construite
      test('make correct http request', () async{
        //Création d'une requête HTTP simulée
        final response = MockResponse();
        //Définition du code de statut HTTP de la réponse simulée 
        when(() => response.statusCode).thenReturn(200);
        //Définition du coprs de la réponse simulée
        when(() => response.body).thenReturn('{}');
        //Défintion du comportement du client HTTP mock lorsqu'il reçoit une requête
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        try {
          //appel de ma méthode de recherche de Location
          await apiClient.locationSearch(query);
        } catch (_) {}     //Gestion silencieuse des erreurs éventuelles   

        //Vérification que le Client HTTP Mock a été appelée avec les bons paramètres
        verify(
          () => httpClient.get(
            Uri.https(
              'geocoding-api.meteo.com', //hôte de l'URI
              '/v1/search', //Chemin de l'URI
              {'name' : query, 'count': '1'} //paramètre de la requête
            ),
          )
        ).called(1);//vérification que la méthode get du client HTTP a été appelée axectement une fois
      });

      //test pour vérifier que la 
      test('throw LocationRequestFailure on non-200 response', () async {
        //Création d'un requête HTTP simulé avec un code de statut non-200
        final response = MockResponse();
        //Définition du code de status de la réponse simulé
        when(() => response.statusCode).thenReturn(400);
        //Définition du comportement du client HTTP mock pour renvoyer la réponse simulé
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        //Vérification que la méthode locationSearch lance une LocationResquesrFailure en cas de réponse non-200
        expect(
          () async => apiClient.locationSearch(query),
          throwsA(isA<LocationRequestFailure>())
        );
      });

      test('throw LocationNotFoundFailure on empty response', () async {
        //Création d'un requête HTTP simulé 
        final response = MockResponse();
        //Définition du code de status de la réponse simulé
        when(() => response.statusCode).thenReturn(200);
        //Définition du corps de la réponse simulé
        when(() => response.body).thenReturn('{"result" : []}');
        //Définition du comportement du client HTTP mock pour renvoyer la réponse simulé
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        //Vérification que la méthode locationSearch lance une LocationNotFoundFailure en cas de la réponse simulé
        await expectLater(
          apiClient.locationSearch(query),
          throwsA(isA<LocationNotFoundFailure>())
        );
      });

      test('returns Location on valid response', () async {
        //Création d'un requête HTTP simulé
        final response = MockResponse();
        //Définition du code de status de la réponse simulé
        when(() => response.statusCode).thenReturn(200);
        //Définition du corps de la réponse simulé
        when(() => response.body).thenReturn(
          '''
          {
            "result" : [
              {
                "id"        : 4887398,
                "name"      : "chicago",
                "latitude"  : 41.85003,
                "longitude" : -87.65005
              }
            ]
          }
          '''
        );
        //Définition du comportement du client HTTP mock pour renvoyer la réponse simule
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final actual = await apiClient.locationSearch(query);
        //Vérification 
        expect(
          actual,
          isA<Location>()
            .having((p0) => p0.id, 'id', 4887398)
            .having((p0) => p0.name, 'name', 'chicago')
            .having((p0) => p0.latitude, 'latitude', 41.85003)
            .having((p0) => p0.longitude, 'longitude', -87.65005)
        );
      });
    });

  group('getWeather', () {
    const latitude = 41.85003;
    const longitude = -85.65005;

    test('makes correct http request', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      try {
        await apiClient.getWeather(latitude: latitude, longitude: longitude);
      } catch (_) {}

      verify(
        () => httpClient.get(
          Uri.https('api.open-meteo.com', 'v1/forecast', {
            'latitude'    : '$latitude',
            'longitude'   : '$longitude',
            'current_weahter' : 'true',
          }),
        ),
      ).called(1);
    });

    test('throws WeatherRequestFailure on non-200 response', () async{
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(
        () async => await apiClient.getWeather(latitude: latitude, longitude: longitude),
        throwsA(isA<WeatherRequestFailure>())
      );
    });

    test('throws WeatherNotFoundFailuer on empty response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(
        () async => apiClient.getWeather(latitude: latitude, longitude: longitude),
        throwsA(isA<WeatherNotFOundFailure>())
      );
    });

    test('returns weather on valid repsonse', () async {

      final response = MockResponse();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
        '''
        {
          "latitude"              : 43,
          "longitude"             : -87.875,
          "generationtime_ms"     : 0.2510547637939453,
          "utc_offset_seconds"    : 0,
          "timezone"              : "GMT",
          "timezone_abbreviation" : "GMT",
          "elevation"             : 189,
          "current_weather"       : 
          {
            "temperature"   : 15.3,
            "windspeed"     : 25.8,
            "winddirection" : 310,
            "weathercode"   : 63,
            "time"          : "2022-09-12T01:00"
          }
        }
        '''
      );
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final actual = await apiClient.getWeather(latitude: latitude, longitude: longitude);

      expect(
        actual,
        isA<Weather>()
          .having((w) => w.temperature, 'temperature', 15.3)
          .having((w) => w.weatherCode, 'weathercode', 63)
      );
    });

  });

  });
}