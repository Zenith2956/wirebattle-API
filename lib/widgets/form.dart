import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../repositories/database_provider.dart';
import '../states/user_provider.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ------------------------------------------------------------
  // SAVE USER
  // ------------------------------------------------------------
  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 1. Créer un user SANS ID
    final newUser = User(
      id: null,
      username: username,
      email: email,
      password: password,
      score: 0,
    );

    try {
      // 2. Insérer en base → retourne un int (ID)
      final insertedId = await DatabaseProvider().insert(newUser);

      // 3. Recréer un user COMPLET avec l'ID
      final userWithId = User(
        id: insertedId,
        username: username,
        email: email,
        password: password,
        score: 0,
      );

      // 4. Login avec un User (pas un int)
      Provider.of<UserProvider>(context, listen: false).login(userWithId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur créé avec succès !")),
      );

    } catch (e) {
      print("ERROR inserting user: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création : $e")),
      );
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // USERNAME
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: "Nom d'utilisateur",
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) =>
                value == null || value.isEmpty ? "Entrez un nom" : null,
          ),

          const SizedBox(height: 15),

          // EMAIL
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) return "Entrez un email";
              if (!value.contains("@")) return "Email invalide";
              return null;
            },
          ),

          const SizedBox(height: 15),

          // PASSWORD
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) =>
                value == null || value.length < 3 ? "Min 3 caractères" : null,
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: _saveUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text(
              "Créer le profil",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
