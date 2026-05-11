import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_color.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final bool isActive;
  final bool showBorder;
  final int cacheVersion;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 14,
    this.isActive = false,
    this.showBorder = false,
    this.cacheVersion = 0,
  });

  String get _initial => name.isNotEmpty ? name[0].toUpperCase() : 'P';

  bool get _isLocalPath => imageUrl != null && imageUrl!.startsWith('/');

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColors.blue : Colors.grey;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.blue : Colors.grey.shade300,
        border: showBorder ? Border.all(color: borderColor, width: 2) : null,
      ),
      child: ClipOval(
        child: hasImage
            ? _isLocalPath
                  // Local file — use Image.file
                  ? Image.file(
                      File(imageUrl!),
                      key: ValueKey('${imageUrl}_$cacheVersion'),
                      fit: BoxFit.cover,
                      width: radius * 2,
                      height: radius * 2,
                      errorBuilder: (_, __, ___) => _buildInitial(),
                    )
                  // Remote URL — use CachedNetworkImage
                  : CachedNetworkImage(
                      key: ValueKey('${imageUrl}_$cacheVersion'),
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      width: radius * 2,
                      height: radius * 2,
                      errorWidget: (_, __, ___) => _buildInitial(),
                    )
            : _buildInitial(),
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
