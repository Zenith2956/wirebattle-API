import '../models/card_model.dart';
import '../models/player.dart';
import 'cards_service.dart';

class GameEngine {
  final CardsService api = CardsService();

  Future<Map<String, dynamic>> startGame() async {
    final raw = await api.fetchCards();

    if (raw.isEmpty) {
      return {
        "p1": Player(name: "Joueur 1", hand: []),
        "p2": Player(name: "IA", hand: []),
        "p1Deck": <CardModel>[],
        "p2Deck": <CardModel>[],
        "powerUps": <CardModel>[],
      };
    }

    final List<CardModel> allCards = [];
    final List<CardModel> powerUps = [];

    // Charger les cartes
    raw.forEach((key, value) {
      final card = CardModel.fromApi(key, value);

      if (key.startsWith("Power_up")) {
        powerUps.add(card);
      } else {
        // 🔥 Multiplier les cartes normales (ex : 4 fois)
        for (int i = 0; i < 4; i++) {
          allCards.add(card);
        }
      }
    });


    allCards.shuffle();

    // 3 cartes en main
    final p1Hand = allCards.take(3).toList();
    final p2Hand = allCards.skip(3).take(3).toList();

    // 25 cartes de pioche chacun
    final p1Deck = allCards.skip(6).take(25).toList();
    final p2Deck = allCards.skip(31).take(25).toList();

    final p1 = Player(name: "Joueur 1", hand: p1Hand);
    final p2 = Player(name: "IA", hand: p2Hand);

    return {
      "p1": p1,
      "p2": p2,
      "p1Deck": p1Deck,
      "p2Deck": p2Deck,
      "powerUps": powerUps,
    };
  }
}
