import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'local_svg_card.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    required this.card,
    this.width = 70,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgCard(
      assetPath: card.assetPath,
      width: width,
      height: height,
    );
  }
}
