import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodImagePage extends StatelessWidget {
  const FoodImagePage({
    required this.imageUrl,
  });

  final String imageUrl;

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
          imageUrl: imageUrl,
          errorWidget: (context, url, dynamic error) => Assets.genericFood.svg(height: defaultSize),
        ),
      ),
    );
  }
}
