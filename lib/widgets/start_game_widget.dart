import 'package:flutter/material.dart';
import '../services/game_engine.dart';
import 'start_game_button.dart';

class StartGameWidget extends StatelessWidget {
  StartGameWidget({super.key});

  final GameEngine engine = GameEngine();

  @override
  Widget build(BuildContext context) {
    return StartGameButton(
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );

        final gameData = await engine.startGame();
        print("GAME DATA = $gameData");

        Navigator.pop(context); // ferme le loader

        Navigator.pushNamed(
          context,
          "/gameboard",
          arguments: gameData,
        );
      },

    );
  }
}
