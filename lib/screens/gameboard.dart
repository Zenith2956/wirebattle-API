import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/card_widget.dart';
import '../controllers/game_controller.dart';
import '../models/player.dart';
import '../models/card_model.dart';
import '../states/user_provider.dart';

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  late GameController controller;
  bool isReady = false;

  bool waitingSecondCardP1 = false;

  CardModel? p1BattleCard;
  CardModel? p2BattleCard;

  CardModel? activePowerUpAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! Map) {
      print("❌ Aucun argument reçu pour GameBoard");
      return;
    }

    final data = args as Map;

    controller = GameController(
      p1: data["p1"] as Player,
      p2: data["p2"] as Player,
      p1Deck: List<CardModel>.from(data["p1Deck"]),
      p2Deck: List<CardModel>.from(data["p2Deck"]),
      powerUps: List<CardModel>.from(data["powerUps"]),
    );

    setState(() => isReady = true);
  }

  // ------------------------------------------------------------
  // CONFIRMATION POWER-UP
  // ------------------------------------------------------------
  Future<bool> confirmPowerUp(CardModel pu) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(pu.title, style: const TextStyle(color: Colors.white)),
        content: Text(pu.texte, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Non", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Oui",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }

  void showPowerUpAnimation(CardModel pu) {
    setState(() => activePowerUpAnimation = pu);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => activePowerUpAnimation = null);
      }
    });
  }

  // ------------------------------------------------------------
  // ACTION JOUEUR
  // ------------------------------------------------------------
  void playCardP1(int index) {
    if (controller.currentPlayer != 1) return;

    if (controller.p1ActivePowerUp?.id == "Power_up4") {
      if (!waitingSecondCardP1) {
        setState(() {
          p1BattleCard = controller.playCard(controller.p1, index);
          waitingSecondCardP1 = true;
        });
        return;
      } else {
        setState(() {
          controller.playCard(controller.p1, index);
          waitingSecondCardP1 = false;
        });
      }
    } else {
      setState(() {
        p1BattleCard = controller.playCard(controller.p1, index);
      });
    }

    controller.currentPlayer = 2;

    Future.delayed(const Duration(milliseconds: 600), aiTurn);
  }

  // ------------------------------------------------------------
  // IA
  // ------------------------------------------------------------
  void aiTurn() {
    if (controller.currentPlayer != 2) return;

    if (controller.p2ActivePowerUp != null) {
      showPowerUpAnimation(controller.p2ActivePowerUp!);
    }

    setState(() {
      p2BattleCard = controller.playCard(controller.p2, 0);
      controller.currentPlayer = 1;
    });

    Future.delayed(const Duration(milliseconds: 800), resolveBattle);
  }

  // ------------------------------------------------------------
  // RÉSOLUTION DU COMBAT
  // ------------------------------------------------------------
  void resolveBattle() {
    controller.resolveRound();

    if (controller.isGameOver()) {
      final winner = controller.getWinner();
      showEndGameDialog(winner);
      return;
    }

    setState(() {
      p1BattleCard = null;
      p2BattleCard = null;
    });
  }

  // ------------------------------------------------------------
  // FIN DE PARTIE
  // ------------------------------------------------------------
  void showEndGameDialog(String winner) async {
    if (winner == "Joueur 1") {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.addScore(5);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "Fin de la partie",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          winner == "Égalité"
              ? "La partie se termine sur une égalité."
              : "$winner remporte la partie !",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Retour au menu",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: SvgPicture.asset("assets/logow.svg", height: 45),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IA en haut
                _playerZone(
                  playerName: "IA",
                  color: Colors.amberAccent,
                  hand: controller.p2.hand,
                  deck: controller.p2Deck,
                  powerUps: controller.p2PowerUpZone,
                  onCardTap: (_) {},
                  onPowerUpTap: (_) {},
                  isAI: true,
                ),

                _battleZone(),

                // Joueur connecté en bas
                _playerZone(
                  playerName: userProvider.currentUser?.username ?? "Joueur 1",
                  color: Colors.purpleAccent,
                  hand: controller.p1.hand,
                  deck: controller.p1Deck,
                  powerUps: controller.p1PowerUpZone,
                  onCardTap: playCardP1,
                  onPowerUpTap: (pu) async {
                    final use = await confirmPowerUp(pu);

                    if (!use) return;

                    setState(() {
                      controller.p1ActivePowerUp = pu;

                      if (pu.id == "Power_up1") controller.usePowerUp1(1);
                      if (pu.id == "Power_up2") controller.usePowerUp2(1);
                      if (pu.id == "Power_up4") waitingSecondCardP1 = false;

                      controller.p1PowerUpZone.remove(pu); // ✔ ici seulement
                    });

                    // Animation centrale
                    showPowerUpAnimation(pu);
                  },
                ),
              ],
            ),
          ),

          // Animation centrale
          if (activePowerUpAnimation != null)
            Center(
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        activePowerUpAnimation!.assetPath,
                        height: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        activePowerUpAnimation!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activePowerUpAnimation!.texte,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ZONE JOUEUR
  // ------------------------------------------------------------
  Widget _playerZone({
    required String playerName,
    required Color color,
    required List<CardModel> hand,
    required List<CardModel> deck,
    required List<CardModel> powerUps,
    required Function(int) onCardTap,
    required Function(CardModel) onPowerUpTap,
    bool isAI = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color.withOpacity(0.5), width: 2),
          bottom: BorderSide(color: color.withOpacity(0.5), width: 2),
        ),
      ),
      child: Column(
        children: [
          Text(
            playerName,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // MAIN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 110,
                width: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hand.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CardWidget(
                        card: hand[i],
                        onTap: isAI ? null : () => onCardTap(i),
                      ),
                    );
                  },
                ),
              ),

              // PIOCHE
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.help, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Pioche : ${deck.length}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // POWERUPS
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: powerUps.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CardWidget(
                    card: powerUps[i],
                    width: 60,
                    height: 60,
                    onTap: isAI ? null : () => onPowerUpTap(powerUps[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BATTLE ZONE
  // ------------------------------------------------------------
  Widget _battleZone() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "BATTLE ZONE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _battleCard(p1BattleCard),
              const SizedBox(width: 20),
              const Text(
                "VS",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(width: 20),
              _battleCard(p2BattleCard),
            ],
          ),
        ],
      ),
    );
  }

  Widget _battleCard(CardModel? card) {
    return Container(
      height: 120,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: card == null
          ? const Center(
              child: Text("...", style: TextStyle(color: Colors.white70)),
            )
          : CardWidget(card: card, width: 80, height: 120),
    );
  }
}
