//Importation de la biblio contenant la classe modèles
import 'package:open_meteo_api/open_meteo_api.dart';
//importation du package de test de DART
import 'package:test/test.dart';

void main() {
  //Définition d'un groupe de test pour la classe Location
  group('Location', () {
    //Définition d'un sous-groupe de test pour la méthode fromJsom
    group('fromJson', () {
      //Définition d'un test pour vérifier si la méthode fromJson retourne 
      //l'objet Location correcte
      test('returns correct Location object', () {
        //Utilisation de la fonction expect pour vérifier le résultat
        expect(
          Location.fromJson( //appel de la fonction fromJson pour créer un objet Location à partir d'un Map
            <String, dynamic> {//définition d'un map contenant les données de Location
              'id' : 4887398, //ID de la location
              'name' : 'Chicago', //Nom de la Location
              'latitude' : 41.85003, //Latitude de la Location
              'longitude' : -87.65005, //Longitude de la Location
            },
          ), 
          isA<Location>() //Vérification que le resultat est bien une instance de la classe Location 
            .having((w) => w.id, 'id', 4887398) //Vérification de l'ID de la Location
            .having((w) => w.name, 'name', 'Chicago') //Vérif du nom de la Location
            .having((w) => w.latitude, 'latitude', 41.85003) //vérif de la latitude de la Location
            .having((w) => w.longitude, 'longitude', -85.65005) //vérif de la longitude de la Location
        );
      });
    });
  });
}