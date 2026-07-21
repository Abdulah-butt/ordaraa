import 'package:flutter/widgets.dart';

import '../../../../core/extensions/theme_extension.dart';

class SplashLoadingIndicator extends StatefulWidget {
  const SplashLoadingIndicator({super.key});

  @override
  State<SplashLoadingIndicator> createState() => _SplashLoadingIndicatorState();
}

class _SplashLoadingIndicatorState extends State<SplashLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final phase = _controller.value * 3;
              final directDistance = (phase - index).abs();
              final distance = directDistance > 1.5
                  ? 3 - directDistance
                  : directDistance;
              final rawStrength = (1 - distance).clamp(0.0, 1.0);
              final strength = Curves.easeInOut.transform(rawStrength);

              return Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 7),
                child: _Segment(
                  width: 8 + (16 * strength),
                  color: Color.lerp(
                    context.colorTheme.outlineVariant,
                    context.colorTheme.primary,
                    strength,
                  )!,
                  opacity: 0.5 + (0.5 * strength),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.width,
    required this.color,
    required this.opacity,
  });

  final double width;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
