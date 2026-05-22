import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'local_svg_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const CardWidget({
    required this.card,
    this.width = 80,
    this.height = 120,
    this.onTap,
    super.key,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Transform.scale(
          scale: _isPressed ? 1.35 : 1.0,
          child: SvgPicture.asset(widget.card.assetPath),
        ),
      ),
    );
  }
}
