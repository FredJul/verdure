import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import 'extensions.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    Key? key,
    required this.food,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  static const minHeight = 104.0;
  static const minWidth = 296.0;

  final Food food;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Tap(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Hero(
                  tag: food.barcode,
                  child: FoodIcon(food: food, size: 86),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (food.brands != null || food.quantity != null)
                        Text(
                          '${food.brands ?? ''}${food.brands != null && food.quantity != null ? ' - ' : ''}${food.quantity ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.caption,
                        ),
                      const Gap(4),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: EcoscoreImage(grade: food.ecoscoreGrade),
                          ),
                          const Gap(12),
                          NutriscoreImage(grade: food.nutriscoreGrade),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodIcon extends StatelessWidget {
  const FoodIcon({
    Key? key,
    required this.food,
    required this.size,
  }) : super(key: key);

  final Food food;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: food.imageFrontUrl == null
          ? SizedBox(
              height: size,
              width: size,
              child: Center(
                child: Assets.genericFood.svg(
                  width: size - 16,
                  height: size - 16,
                ),
              ),
            )
          : CachedNetworkImage(
              height: size,
              width: size,
              fit: BoxFit.cover,
              imageUrl: food.imageFrontUrl!,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.white,
                child: Container(
                  width: size,
                  height: size,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, dynamic error) => Center(
                child: Assets.genericFood.svg(
                  width: size - 16,
                  height: size - 16,
                ),
              ),
            ),
    );
  }
}

class EcoscoreImage extends StatelessWidget {
  const EcoscoreImage({
    this.grade,
    this.height = 32.0,
  });

  final Grade? grade;
  final double height;

  @override
  Widget build(BuildContext context) {
    switch (grade) {
      case Grade.a:
        return Assets.ecoscoreA.svg(height: height);
      case Grade.b:
        return Assets.ecoscoreB.svg(height: height);
      case Grade.c:
        return Assets.ecoscoreC.svg(height: height);
      case Grade.d:
        return Assets.ecoscoreD.svg(height: height);
      case Grade.e:
        return Assets.ecoscoreE.svg(height: height);
      case Grade.notApplicable:
        return const SizedBox(); // We display nothing when not applicable
      case null:
        return Assets.ecoscoreUnknown.svg(height: height);
    }
  }
}

class NutriscoreImage extends StatelessWidget {
  const NutriscoreImage({
    this.grade,
    this.height = 38.0,
  });

  final Grade? grade;
  final double height;

  @override
  Widget build(BuildContext context) {
    switch (grade) {
      case Grade.a:
        return Assets.nutriscoreA.svg(height: height);
      case Grade.b:
        return Assets.nutriscoreB.svg(height: height);
      case Grade.c:
        return Assets.nutriscoreC.svg(height: height);
      case Grade.d:
        return Assets.nutriscoreD.svg(height: height);
      case Grade.e:
        return Assets.nutriscoreE.svg(height: height);
      case Grade.notApplicable:
        return const SizedBox(); // We display nothing when not applicable
      case null:
        return Assets.nutriscoreUnknown.svg(height: height);
    }
  }
}
