import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodImagePage extends StatelessWidget {
  const FoodImagePage({
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context) {
    const defaultSize = 224.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: food.imageFrontUrl!,
          errorWidget: (context, url, dynamic error) => Assets.genericFood.svg(height: defaultSize),
        ),
      ),
    );
  }
}
