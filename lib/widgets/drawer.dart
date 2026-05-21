import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wirebattle/states/user_provider.dart';
import '../screens/accueil.dart';
import '../screens/cards.dart';
import '../screens/rules.dart';
import '../screens/gameboard.dart';
import '../screens/profile.dart';
import '../states/menu_provider.dart';
import '../services/game_engine.dart';
import 'package:provider/provider.dart';
import '../screens/scoreboard.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/logow.svg', height: 70),
                  const SizedBox(height: 10),

                  Text(
                    user != null ? "Hello, ${user.username}" : "Not logged in",
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            _drawerItem(
              context: context,
              label: "Home",
              menuKey: "Home",
              icon: Icons.home,
              destination: const HomeScreen(),
            ),

            _drawerItem(
              context: context,
              label: "Cards",
              menuKey: "Cards",
              icon: Icons.style,
              destination: const CardsScreen(),
            ),

            _drawerItem(
              context: context,
              label: "Rules",
              menuKey: "Rules",
              icon: Icons.rule,
              destination: const RulesScreen(),
            ),

            _drawerItem(
              context: context,
              label: "Scores",
              menuKey: "Scores",
              icon: Icons.leaderboard,
              destination: const ScoreBoardScreen(),
            ),

            _drawerItem(
              context: context,
              label: "Nouvelle partie",
              menuKey: "NewGame",
              icon: Icons.sports_esports,
              destination: null, // on gère manuellement
              onTapOverride: () async {
                final nav = Navigator.of(context);

                nav.pop();

                showDialog(
                  context: nav.context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );

                final engine = GameEngine();
                final gameData = await engine.startGame();

                nav.pop();

                nav.pushNamed("/gameboard", arguments: gameData);
              },
            ),

            _drawerItem(
              context: context,
              label: "Profile",
              menuKey: "Profile",
              icon: Icons.person,
              destination: const ProfileScreen(),
            ),

            const SizedBox(height: 20),

            if (user != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  context.read<UserProvider>().logout();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

Widget _drawerItem({
  required BuildContext context,
  required String label,
  required String menuKey,
  required IconData icon,
  required Widget? destination,
  Function()? onTapOverride,
}) {
  final bool isSelected = context.watch<MenuProvider>().menu == menuKey;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isSelected
          ? Colors.purpleAccent.withOpacity(0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isSelected ? Colors.purpleAccent : Colors.white24,
        width: isSelected ? 2 : 1,
      ),
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.purpleAccent : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.purpleAccent : Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      onTap: () {
        context.read<MenuProvider>().changeMenu(menuKey);
        Navigator.pop(context);

        if (onTapOverride != null) {
          onTapOverride();
        } else if (destination != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    ),
  );
}
