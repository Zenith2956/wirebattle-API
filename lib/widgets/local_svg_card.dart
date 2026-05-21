import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalSvgCard extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const LocalSvgCard({
    super.key,
    required this.assetPath,
    this.width = 70,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
