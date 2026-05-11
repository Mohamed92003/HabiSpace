import 'package:flutter/material.dart';

/// A shimmer placeholder shown while a network image is loading.
///
/// Always expands to fill its parent via [SizedBox.expand], so it works
/// correctly inside [CachedNetworkImage]'s placeholder callback without
/// needing explicit width/height values.
class ImageShimmer extends StatefulWidget {
  const ImageShimmer({super.key});

  @override
  State<ImageShimmer> createState() => _ImageShimmerState();
}

class _ImageShimmerState extends State<ImageShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);
    final highlightColor = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFF5F5F5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  baseColor,
                  Color.lerp(baseColor, highlightColor, _animation.value)!,
                  baseColor,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
