import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/drawer.dart';

class CardsScreen extends StatefulWidget {
  final String? initialCardKey;

  const CardsScreen({super.key, this.initialCardKey});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> cards = {};
  List<String> keys = [];
  int currentIndex = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    loadCards();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> loadCards() async {
    final url = Uri.parse(
      "https://zenith2956.github.io/WireBattle/cards.json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        cards = jsonData;
        keys = cards.keys.toList();

        if (widget.initialCardKey != null &&
            keys.contains(widget.initialCardKey)) {
          currentIndex = keys.indexOf(widget.initialCardKey!);
        }
      });

      _fadeController.forward(from: 0);
    }
  }

  void loadCard(int index) {
    setState(() {
      currentIndex = index;
    });
    _fadeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool loaded = cards.isNotEmpty;

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
          child: loaded
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "WireBattle – Cards",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF1A1A1A),
                          value: keys[currentIndex],
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.amberAccent,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          items: keys.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(cards[key]["title"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final newIndex = keys.indexOf(value!);
                            loadCard(newIndex);
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          height: 320,
                          width: 240,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.purpleAccent.withOpacity(0.6),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.25),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: SvgPicture.asset(
                            "assets/cards/${cards[keys[currentIndex]]['image'].split('/').last}",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cards[keys[currentIndex]]["texte"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _navButton(
                            label: "Previous",
                            onTap: () {
                              final newIndex =
                                  (currentIndex - 1 + keys.length) %
                                  keys.length;
                              loadCard(newIndex);
                            },
                          ),
                          const SizedBox(width: 20),
                          _navButton(
                            label: "Next",
                            onTap: () {
                              final newIndex = (currentIndex + 1) % keys.length;
                              loadCard(newIndex);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.amberAccent),
                ),
        ),
      ),
    );
  }

  Widget _navButton({required String label, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purpleAccent.withOpacity(0.15),
        foregroundColor: Colors.purpleAccent,
        side: const BorderSide(color: Colors.purpleAccent, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
