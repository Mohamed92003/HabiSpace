import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_color.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final bool isActive;
  final bool showBorder;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 14,
    this.isActive = false,
    this.showBorder = false,
  });

  String get _initial =>
      name.isNotEmpty ? name[0].toUpperCase() : 'P';

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColors.blue : Colors.grey;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.blue : Colors.grey.shade300,
        border: showBorder
            ? Border.all(color: borderColor, width: 2)
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                errorWidget: (_, __, ___) => _buildInitial(),
              )
            : CachedNetworkImage(
                imageUrl: 'https://i.pinimg.com/474x/7a/24/75/7a247579a370259119ed42b4bdddeea1.jpg',
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                errorWidget: (_, __, ___) => _buildInitial(),
              ),
      ),
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Text(
        _initial,
        style: TextStyle(
          fontSize: radius * 0.85,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
