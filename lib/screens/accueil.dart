import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> cards = {};

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    final url = Uri.parse(
      "https://zenith2956.github.io/WireBattle/cards.json",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        cards = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading:
            true,
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
            child: Column(
              children: [
                const SizedBox(height: 20),

                SvgPicture.asset("assets/logow.svg", height: 120),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 12,
                  children: [
                    _wbButton(
                      label: "View Rules",
                      color: Colors.amberAccent,
                      onTap: () => Navigator.pushNamed(context, "/rules"),
                    ),
                    _wbButton(
                      label: "View Cards",
                      color: Colors.purpleAccent,
                      onTap: () => Navigator.pushNamed(context, "/cards"),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: cards.isEmpty
                      ? const CircularProgressIndicator(
                          color: Colors.amberAccent,
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cards.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            final key = cards.keys.elementAt(index);
                            final card = cards[key];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/cards",
                                  arguments: key,
                                );
                              },
                              child: _wbCardPreview(card),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wbButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        side: BorderSide(color: color, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _wbCardPreview(dynamic card) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        color: Colors.black.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          "assets/cards/${card['image'].split('/').last}",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
