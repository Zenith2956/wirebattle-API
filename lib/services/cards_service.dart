import 'dart:convert';
import 'package:http/http.dart' as http;

class CardsService {
  final String url = "https://zenith2956.github.io/WireBattle/cards.json";

  Future<Map<String, dynamic>> fetchCards() async {
  final url = Uri.parse("https://zenith2956.github.io/WireBattle/cards.json");

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        print("❌ Timeout: GitHub Pages ne répond pas");
        return http.Response("{}", 500);
      },
    );

    if (response.statusCode != 200) {
      print("❌ Erreur HTTP: ${response.statusCode}");
      return {};
    }

    return jsonDecode(response.body);
  } catch (e) {
    print("❌ Erreur fetchCards(): $e");
    return {};
  }
}

}
