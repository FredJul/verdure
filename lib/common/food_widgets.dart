import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import 'extensions.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    Key? key,
    required this.food,
    this.onTap,
  }) : super(key: key);

  final Food food;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Tap(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              FoodIcon(food: food, size: 72),
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
                        SvgPicture.asset(
                          'assets/ecoscore-${food.ecoscoreGrade ?? 'unknown'}.svg',
                          height: 24,
                        ),
                        const Gap(12),
                        SvgPicture.asset(
                          'assets/nutriscore-${food.nutriscoreGrade ?? 'unknown'}.svg',
                          height: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                child: SvgPicture.asset(
                  'assets/generic_food.svg',
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
              errorWidget: (context, url, dynamic error) => SizedBox(
                height: size,
                width: size,
                child: SizedBox(
                  height: size,
                  width: size,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/generic_food.svg',
                      width: size - 16,
                      height: size - 16,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
