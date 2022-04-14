import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Tap extends StatelessWidget {
  const Tap({
    Key? key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.customBorder,
    this.borderRadius,
  }) : super(key: key);

  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final ShapeBorder? customBorder;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    // Material needed for the InkWell to display correctly
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        customBorder: customBorder,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class DisapearingSliverAppBarTitle extends StatefulWidget {
  const DisapearingSliverAppBarTitle({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _DisapearingSliverAppBarTitleState createState() {
    return _DisapearingSliverAppBarTitleState();
  }
}

class _DisapearingSliverAppBarTitleState extends State<DisapearingSliverAppBarTitle> {
  ScrollPosition? _position;
  bool _visible = false;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

class FadeInAppear extends StatefulWidget {
  const FadeInAppear({
    Key? key,
    this.child,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  final Widget? child;
  final Duration duration;

  @override
  _FadeInAppearState createState() => _FadeInAppearState();
}

class _FadeInAppearState extends State<FadeInAppear> {
  var _init = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _init = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _init ? 1 : 0,
      duration: widget.duration,
      child: widget.child,
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.icon,
    required this.subtitle,
  });

  final SvgGenImage icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon.svg(width: 100),
          const Gap(12),
          Text(subtitle, textAlign: TextAlign.center, style: context.textTheme.caption),
        ],
      ),
    );
  }
}
