import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartGameButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8A2BE2), Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Text(
          "LANCER LA PARTIE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
