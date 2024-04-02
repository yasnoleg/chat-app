import 'dart:math' as math;

import 'package:flutter/material.dart';

class Noise extends StatelessWidget {
  const Noise({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < 25; i++) _singleNoise(context)
      ],
    );
  }

  Widget _singleNoise(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final double height = (22) * math.Random().nextDouble() + 1.5;

    return Padding(
      padding: EdgeInsets.only(right: 1),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: .2),
        width: 2.3,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Colors.white,
        ),
      ),
    );
  }
}