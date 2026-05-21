import 'card_model.dart';

class Player {
  String name;
  List<CardModel> hand;

  Player({
    required this.name,
    required this.hand,
  });
}
