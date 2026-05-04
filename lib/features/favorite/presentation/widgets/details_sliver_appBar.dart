import 'package:flutter/material.dart';
import 'package:habispace/features/favorite/presentation/widgets/property_image_widget.dart';
import 'package:habispace/features/favorite/presentation/widgets/type_badge_widget.dart';
import '../../domain/entities/favorite_property_entity.dart';

class DetailsSliverAppBar extends StatelessWidget {
  final FavoritePropertyEntity property;
  const DetailsSliverAppBar({required this.property});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PropertyImageWidget(
              imageUrl:
              property.images.isNotEmpty ? property.images.first : null,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black38, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: 56,
              child: TypeBadgeWidget(label: property.type),
            ),
          ],
        ),
      ),
    );
  }
}
