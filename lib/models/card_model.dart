// 1. La map globale (au-dessus de la classe)
const Map<String, String> cardAssetMap = {
  "Quick_sketch": "carte_2.svg",
  "Page_breakdown": "carte_3.svg",
  "Block_placement": "carte_4.svg",
  "Adding_columns": "carte_5.svg",
  "Adding_buttons": "carte_6.svg",
  "Adding_placeholder_images": "carte_7.svg",
  "Simple_text": "carte_8.svg",
  "Information_organization": "carte_9.svg",
  "Mobile_version": "carte_10.svg",
  "Clean_alignments": "carte_j.svg",
  "Click_path": "carte_q.svg",
  "Realistic_mockup": "carte_k.svg",
  "Simple_prototype": "carte_a.svg",
  "Power_up1": "carte_p1.svg",
  "Power_up2": "carte_p2.svg",
  "Power_up3": "carte_p3.svg",
  "Power_up4": "carte_p4.svg",
  "Joker": "carte_joker.svg",
};

class CardModel {
  final String id;
  final String title;
  final String texte;
  final String assetPath;
  final int rank;

  CardModel({
    required this.id,
    required this.title,
    required this.texte,
    required this.assetPath,
    required this.rank,
  });

  CardModel copy() {
    return CardModel(
      id: id,
      title: title,
      texte: texte,
      rank: rank,
      assetPath: assetPath,
    );
  }
  // 2. La factory qui utilise la map
  factory CardModel.fromApi(String id, Map<String, dynamic> json) {
    return CardModel(
      id: id,
      title: json["title"],
      texte: json["texte"],
      assetPath: "assets/cards/${cardAssetMap[id]}",
      rank: json["rank"],
    );
  }
}

