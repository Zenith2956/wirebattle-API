import '../models/card_model.dart';
import '../models/player.dart';
import 'dart:math';

class GameController {
  Player p1;
  Player p2;

  List<CardModel> p1Deck;
  List<CardModel> p2Deck;

  List<CardModel> powerUps;

  // Zones spéciales
  List<CardModel> p1PowerUpZone = [];
  List<CardModel> p2PowerUpZone = [];

  // PowerUp actif
  CardModel? p1ActivePowerUp;
  CardModel? p2ActivePowerUp;

  // Pour Power_up4 (jouer 2 cartes)
  CardModel? p1SecondCard;
  CardModel? p2SecondCard;

  int currentPlayer = 1;

  CardModel? p1Played;
  CardModel? p2Played;

  GameController({
    required this.p1,
    required this.p2,
    required this.p1Deck,
    required this.p2Deck,
    required this.powerUps,
  });

  final Random rng = Random();

  // ------------------------------------------------------------
  // PIOCHE
  // ------------------------------------------------------------
  void drawCard(Player player, List<CardModel> deck) {
    if (deck.isEmpty) return;
    if (player.hand.length >= 3) return;
    player.hand.add(deck.removeAt(0));
  }

  // ------------------------------------------------------------
  // ACTIVER UN POWERUP
  // ------------------------------------------------------------
  void activatePowerUp(int player, CardModel pu) {
    if (player == 1) {
      p1ActivePowerUp = pu.copy();
    } else {
      p2ActivePowerUp = pu.copy();
    }
  }

  // ------------------------------------------------------------
  // JOUER UNE CARTE
  // ------------------------------------------------------------
  CardModel playCard(Player player, int index) {
    final card = player.hand.removeAt(index);

    if (player == p1) {
      if (p1ActivePowerUp?.id == "Power_up4" && p1Played != null) {
        p1SecondCard = card;
      } else {
        p1Played = card;
      }
    } else {
      if (p2ActivePowerUp?.id == "Power_up4" && p2Played != null) {
        p2SecondCard = card;
      } else {
        p2Played = card;
      }
    }

    return card;
  }

  // ------------------------------------------------------------
  // RÉSOLUTION DU TOUR
  // ------------------------------------------------------------
  void resolveRound() {
    if (p1Played == null || p2Played == null) return;

    final bool p1IsJoker = p1Played!.id == "Joker";
    final bool p2IsJoker = p2Played!.id == "Joker";

    // ------------------------------------------------------------
    // 🔥 RÈGLE JOKER
    // ------------------------------------------------------------
    if (p1IsJoker && !p2IsJoker) {
      _handleJokerWin(1);
      return;
    }
    if (p2IsJoker && !p1IsJoker) {
      _handleJokerWin(2);
      return;
    }
    if (p1IsJoker && p2IsJoker) {
      _battle();
      return;
    }

    // ------------------------------------------------------------
    // 🔥 CALCUL DES FORCES
    // ------------------------------------------------------------
    int p1Force = p1Played!.rank;
    int p2Force = p2Played!.rank;

    // POWER UP 3 : double la valeur
    if (p1ActivePowerUp?.id == "Power_up3") p1Force *= 2;
    if (p2ActivePowerUp?.id == "Power_up3") p2Force *= 2;

    // POWER UP 4 : jouer 2 cartes
    if (p1ActivePowerUp?.id == "Power_up4" && p1SecondCard != null) {
      p1Force += p1SecondCard!.rank;
    }
    if (p2ActivePowerUp?.id == "Power_up4" && p2SecondCard != null) {
      p2Force += p2SecondCard!.rank;
    }

    // ------------------------------------------------------------
    // 🔥 RÉSOLUTION
    // ------------------------------------------------------------
    if (p1Force > p2Force) {
      _giveCardsToWinner(p1Deck, _collectPlayedCards());
    } else if (p2Force > p1Force) {
      _giveCardsToWinner(p2Deck, _collectPlayedCards());
    } else {
      _battle();
    }

    _resetRound();
  }

  // ------------------------------------------------------------
  // 🔥 GESTION DU JOKER
  // ------------------------------------------------------------
  void _handleJokerWin(int player) {
    // Joker + carte adverse disparaissent
    // Le gagnant pioche un PowerUp
    if (powerUps.isNotEmpty) {
      final pu = powerUps.removeAt(0);
      if (player == 1) {
        p1PowerUpZone.add(pu);
      } else {
        p2PowerUpZone.add(pu);
      }
    }

    _resetRound();
  }

  // ------------------------------------------------------------
  // 🔥 BATAILLE
  // ------------------------------------------------------------
  void _battle() {
    if (p1.hand.length < 2 || p2.hand.length < 2) {
      if (p1.hand.length < 2) {
        p2Deck.addAll(_collectPlayedCards());
      } else {
        p1Deck.addAll(_collectPlayedCards());
      }
      return;
    }

    final p1Hidden = p1.hand.removeAt(0);
    final p2Hidden = p2.hand.removeAt(0);

    final p1Second = p1.hand.removeAt(0);
    final p2Second = p2.hand.removeAt(0);

    if (p1Second.rank > p2Second.rank) {
      _giveCardsToWinner(p1Deck, [
        ..._collectPlayedCards(),
        p1Hidden,
        p2Hidden,
        p1Second,
        p2Second,
      ]);
    } else if (p2Second.rank > p1Second.rank) {
      _giveCardsToWinner(p2Deck, [
        ..._collectPlayedCards(),
        p1Hidden,
        p2Hidden,
        p1Second,
        p2Second,
      ]);
    } else {
      p1Played = p1Second;
      p2Played = p2Second;
      _battle();
    }
  }

  // ------------------------------------------------------------
  // POWER UP 1 : voler une carte
  // ------------------------------------------------------------
  void usePowerUp1(int player) {
    if (player == 1 && p2Deck.isNotEmpty) {
      p1Deck.add(p2Deck.removeAt(rng.nextInt(p2Deck.length)));
    }
    if (player == 2 && p1Deck.isNotEmpty) {
      p2Deck.add(p1Deck.removeAt(rng.nextInt(p1Deck.length)));
    }
  }

  // ------------------------------------------------------------
  // POWER UP 2 : échanger les pioches
  // ------------------------------------------------------------
  void usePowerUp2(int player) {
    final temp = List<CardModel>.from(p1Deck);
    p1Deck = List<CardModel>.from(p2Deck);
    p2Deck = temp;
  }

  // ------------------------------------------------------------
  // OUTILS
  // ------------------------------------------------------------
  List<CardModel> _collectPlayedCards() {
    final list = <CardModel>[];
    if (p1Played != null) list.add(p1Played!);
    if (p2Played != null) list.add(p2Played!);
    if (p1SecondCard != null) list.add(p1SecondCard!);
    if (p2SecondCard != null) list.add(p2SecondCard!);
    return list;
  }

  void _giveCardsToWinner(List<CardModel> deck, List<CardModel> cards) {
    deck.addAll(cards);
    deck.shuffle();
  }

  void _resetRound() {
    p1Played = null;
    p2Played = null;
    p1SecondCard = null;
    p2SecondCard = null;
    p1ActivePowerUp = null;
    p2ActivePowerUp = null;

    while (p1.hand.length < 3 && p1Deck.isNotEmpty) {
      drawCard(p1, p1Deck);
    }

    while (p2.hand.length < 3 && p2Deck.isNotEmpty) {
      drawCard(p2, p2Deck);
    }
  }

  bool isGameOver() {
    return (p1.hand.isEmpty && p1Deck.isEmpty) ||
        (p2.hand.isEmpty && p2Deck.isEmpty);
  }

  String getWinner() {
    if (p1.hand.isEmpty && p1Deck.isEmpty) return "IA";
    if (p2.hand.isEmpty && p2Deck.isEmpty) return "Joueur 1";
    return "Aucun";
  }
}
