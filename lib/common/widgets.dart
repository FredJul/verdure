import 'package:cached_network_image/cached_network_image.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import 'extensions.dart';

class Tap extends StatelessWidget {
  const Tap({
    Key? key,
    this.child,
    this.onTap,
    this.customBorder,
    this.borderRadius,
  }) : super(key: key);

  final Widget? child;
  final GestureTapCallback? onTap;
  final ShapeBorder? customBorder;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    // Material needed for the InkWell to display correctly
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: customBorder,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class AutoAnimList extends StatefulWidget {
  const AutoAnimList({
    Key? key,
    required this.children,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : super(key: key);

  final List<Widget> children;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  @override
  _AutoAnimListState createState() => _AutoAnimListState();
}

class _AutoAnimListState extends State<AutoAnimList> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: widget.children.length,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        return _fadeItem(context, widget.children[index], animation);
      },
    );
  }

  @override
  void didUpdateWidget(covariant AutoAnimList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final diffResult = calculateListDiff<Key?>(
      oldWidget.children.map((w) => w.key).toList(),
      widget.children.map((w) => w.key).toList(),
      detectMoves: false,
    );

    for (final update in diffResult.getUpdates(batch: false)) {
      update.when(
        insert: (pos, count) {
          for (int i = pos; i <= pos + count - 1; i++) {
            _listKey.currentState?.insertItem(i);
          }
        },
        remove: (pos, count) {
          for (int i = count - 1; i >= 0; i--) {
            _listKey.currentState
                ?.removeItem(pos + i, (_, animation) => _fadeItem(context, oldWidget.children[pos + i], animation));
          }
        },
        change: (pos, payload) => throw UnsupportedError,
        move: (from, to) => throw UnsupportedError,
      );
    }
  }

  Widget _fadeItem(BuildContext context, Widget item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: item,
    );
  }
}

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
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: food.imageFrontUrl == null
                    ? const Icon(Icons.error, size: 72)
                    : CachedNetworkImage(
                        height: 72,
                        width: 72,
                        fit: BoxFit.cover,
                        imageUrl: food.imageFrontUrl!,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 72,
                            height: 72,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, dynamic error) => Icon(Icons.error),
                      ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name, overflow: TextOverflow.ellipsis),
                    if (food.brands != null && food.brands!.isNotEmpty)
                      Text(
                        food.brands!,
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
