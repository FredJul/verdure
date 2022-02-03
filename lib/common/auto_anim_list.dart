import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
