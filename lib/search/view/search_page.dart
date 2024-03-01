import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  //Constructeur privé pour éviter l'instanciation de la classe 
  const SearchPage._();

  static Route<String> route() {
    //Crée et renvoie une route vers la page de recherche
    return MaterialPageRoute(builder: (_) => const SearchPage._());
  }

  @override
  State<SearchPage> createState() => _SearchPageState(); //Crée l'état de la page de recherche
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Search'),),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Chicago',
                ),
              ), 
            ) 
          ),
          IconButton(
            //clé utilisée pour les tests 
            key: const Key('searchPage_search_iconButton'),
            //renvoie le texte de rechrerche à l'écran précédent lors de l'appui sur le bouton
            onPressed: () => Navigator.of(context).pop(_text), 
            icon: const Icon(Icons.search, semanticLabel: 'Submit',),
          )
        ],
      ),
    );
  }
}