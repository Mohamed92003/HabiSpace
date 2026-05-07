import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../domain/entities/property_detail_entity.dart';
import 'details_painters.dart';

class DetailsHero extends StatefulWidget {
  final PropertyDetailEntity property;
  final double heroHeight;

  const DetailsHero({
    super.key,
    required this.property,
    required this.heroHeight,
  });

  @override
  State<DetailsHero> createState() => _DetailsHeroState();
}

class _DetailsHeroState extends State<DetailsHero> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.property.images;
    return SizedBox(
      height: widget.heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _currentImageIndex = i),
              itemBuilder: (_, i) => CachedNetworkImage(
               imageUrl:  images[i],
                fit: BoxFit.cover,
                // errorBuilder: (_, __, ___) =>
                //     CustomPaint(painter: HousePainter()),
              ),
              
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.greendark, AppColors.greendark],
                ),
              ),
              child: CustomPaint(painter: HousePainter()),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xDD000000), Colors.transparent],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            left: 18,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.sp24,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    shadows: const [
                      Shadow(blurRadius: 8, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        widget.property.address,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppSizes.sp12,
                          shadows: const [
                            Shadow(blurRadius: 8, color: Colors.black54),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '|',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: AppSizes.sp12,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.near_me_outlined,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '500 miles',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppSizes.sp12,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54),
                        ],
                      ),
                    ),
                    if (widget.property.rating != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '|',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppSizes.sp12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_border_rounded,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        widget.property.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppSizes.sp12,
                          shadows: const [
                            Shadow(blurRadius: 8, color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (images.length > 1) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (i) {
                      final active = i == _currentImageIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
