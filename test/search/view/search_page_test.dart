import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/search/search.dart';

void main() {
  group('SearchPage', () { 
    testWidgets('is routable', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(SearchPage.route());
                }
              ),
            )
          ),
        )
      );

      await widgetTester.tap(find.byType(FloatingActionButton));
      await widgetTester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('returns selected text when popped', (widgetTester) async {
      String? location;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  location = await Navigator.of(context).push(SearchPage.route());
                },
              ),
            )
          ),
        )
      );

      await widgetTester.tap(find.byType(FloatingActionButton));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byType(TextField), 'Chicago');
      await widgetTester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await widgetTester.pumpAndSettle();

      expect(find.byType(SearchPage), findsNothing);
      expect(location, 'Chicago');
    });
  });
}