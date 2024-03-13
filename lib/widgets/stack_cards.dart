import 'package:flutter/material.dart';

class StackOfCards extends StatelessWidget {
  final int num;
  final Widget child;
  final double offset;

  const StackOfCards(this.num, this.child, this.offset, {super.key});

  @override
  Widget build(BuildContext context) {
    int tnum = num < 1 ? 1 : num;
    tnum = tnum > 4 ? 4 : tnum;

    return Stack(
      children: List<Widget>.generate(
        tnum - 1,
        (val) => Positioned(
          bottom: val * offset,
          left: val * offset,
          top: (tnum - val - 1) * offset,
          right: (tnum - val - 1) * offset,
          child: Card(
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black)),
            child: Container(),
          ),
        ),
      ).toList()
        ..add(
          Padding(
            padding: EdgeInsets.only(
                bottom: (tnum - 1) * offset, left: (tnum - 1) * offset),
            child: Card(
              //shape: const RoundedRectangleBorder(),
              child: child,
            ),
          ),
        ),
    );
  }
}
