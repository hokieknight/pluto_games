import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class MyFlipCard extends StatelessWidget {
  final String backImage;
  final String frontImage;
  final bool flippable;
  final double height;

  const MyFlipCard(this.backImage, this.frontImage, this.flippable, this.height,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (!flippable) {
      return Image.asset(
        backImage,
        height: height,
      );
    }

    return FlipCard(
      rotateSide: RotateSide.left,
      onTapFlipping: true,
      axis: FlipAxis.vertical,
      controller: FlipCardController(),
      backWidget: Image.asset(
        frontImage,
        height: height,
      ),
      frontWidget: Image.asset(
        backImage,
        height: height,
      ),
    );
  }
}
