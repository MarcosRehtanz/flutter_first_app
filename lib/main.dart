import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void next() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  bool isFavorite() {
    return favorites.contains(current);
  }
  void toggleFavorite() {
    if(isFavorite()){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) => {
                print('selected: $value')
              },
            ),
          ),
          Expanded(child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: GeneratorPage(),
          ))
        ],
      )
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LikeButton(appState: appState),
              SizedBox(width: 10),
              NextButton(appState: appState),
            ],
          )
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: appState.next,
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text('Next'),
        Icon(Icons.skip_next),
      ]),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.appState,
  });

  final MyAppState appState;


  @override
  Widget build(BuildContext context) {
    
    IconData icon;
    if(appState.isFavorite()){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return ElevatedButton(
      onPressed: appState.toggleFavorite,
      child: Icon(icon)
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onPrimary
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: '${pair.first} ${pair.second}',
        ),
      ),
    );
  }
}
