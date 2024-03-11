import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class MyFlipCard extends StatelessWidget {
  final String backImage;
  final String frontImage;

  const MyFlipCard(this.backImage, this.frontImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: FlipCard(
        rotateSide: RotateSide.left,
        onTapFlipping: true,
        axis: FlipAxis.vertical,
        controller: FlipCardController(),
        backWidget: Image.asset(
          frontImage,
          //width: 100,
          height: 100,
        ),
        frontWidget: Image.asset(
          backImage,
          //width: 100,
          height: 100,
        ),
      ),
    );
  }
}
