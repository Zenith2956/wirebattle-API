import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wirebattle/screens/accueil.dart';
import 'package:wirebattle/screens/cards.dart';
import 'package:wirebattle/screens/rules.dart';
import 'package:wirebattle/screens/gameboard.dart';
import 'package:wirebattle/screens/profile.dart';
import 'package:wirebattle/screens/scoreboard.dart';
import 'package:wirebattle/states/user_provider.dart';
import 'states/menu_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const WireBattleApp(),
    ),
  );
}


class WireBattleApp extends StatelessWidget {
  const WireBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WireBattle',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cards': (context) => const CardsScreen(),
        '/rules': (context) => const RulesScreen(),
        '/gameboard': (context) => const GameBoardScreen(),
        '/profile': (context) => ProfileScreen(),
        "/scores": (context) => const ScoreBoardScreen(),

      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Courier New",
      ),
      home: const HomeScreen(),
    );
  }
}
