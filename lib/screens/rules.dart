import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.amberAccent,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget bulletList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "•  ",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading:
            true, // 🔥 IMPORTANT pour afficher le bouton Drawer
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: SvgPicture.asset("assets/logow.svg", height: 45),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SvgPicture.asset("assets/logow.svg", height: 90),

                const SizedBox(height: 20),

                sectionTitle("🎲 Game Rules"),
                paragraph(
                  "This serious game is played with 56 cards and involves 2 to 4 players.",
                ),

                sectionTitle("🎨 Card Color Rank"),
                paragraph(
                  "Cards are categorized by color according to their rank or type:",
                ),
                const SizedBox(height: 10),
                bulletList([
                  "🟢 Green Cards: Card N°2 to N°5",
                  "🔵 Blue Cards: Card N°6 to N°10",
                  "🔴 Red Cards: Card Jack (J) to Ace",
                  "🟡 Yellow Cards: Joker",
                  "🟣 Purple Cards: Power-up",
                ]),

                sectionTitle("1. ⏱️ Game Setup"),
                bulletList([
                  "Players scan the QR code to access the rules and card power order.",
                  "The 56-card deck is distributed face-down. Players place their deck on the board without looking.",
                  "Each player takes a blank sheet of paper.",
                ]),

                sectionTitle("2. 🎮 Gameplay"),
                bulletList([
                  "Based on the game “La Bataille”, each player reveals the top card of their deck.",
                  "The highest card wins the trick and collects all cards played.",
                  "Special Action: When drawing a new card in ascending order, players must draw the corresponding wireframe step on their sheet.",
                ]),

                sectionTitle("🏆 How to Win"),
                paragraph(
                  "To win, you must collect all 56 cards by defeating your opponents.",
                ),

                sectionTitle("🛠️ Equipment Needed"),
                bulletList(["Blank sheet", "Pen", "Smartphone"]),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
