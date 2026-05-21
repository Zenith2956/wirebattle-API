import 'package:wirebattle/models/card_model.dart';
import 'package:wirebattle/services/cards_service.dart';

class CardsRepository {
  final CardsService service = CardsService();

  Future<List<CardModel>> getCards() async {
    final jsonData = await service.fetchCards();

    final List<CardModel> cards = [];

    jsonData.forEach((key, value) {
      cards.add(
        CardModel.fromApi(
          key,
          value,
        ),
      );
    });

    return cards;
  }
}
