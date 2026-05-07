import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habispace/core/constants/api_constant.dart';

class PropertyImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final BorderRadius? borderRadius;

  const PropertyImageWidget({
    super.key,
    this.imageUrl,
    this.height,
    this.borderRadius,
  });

  static String resolveUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = ApiConstant.baseUrl.replaceAll('/api/v1', '');
    final joined = '$base/$url';
    return joined.replaceAllMapped(RegExp(r'(?<!:)//'), (_) => '/');
  }

  static bool _isSvg(String url) {
    final lower = url.toLowerCase();
    return lower.contains('placehold.co') ||
        lower.endsWith('.svg') ||
        lower.contains('placeholder');
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final resolved = (url != null && url.isNotEmpty) ? resolveUrl(url) : null;

    Widget image;

    if (resolved == null) {
      image = _Placeholder(height: height ?? 200);
    } else if (_isSvg(resolved)) {

      image = SvgPicture.network(
        resolved,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        headers: const {'User-Agent': 'Mozilla/5.0'},
        placeholderBuilder: (_) => _Placeholder(height: height ?? 200, loading: true),
      );

      image = SizedBox(
        width: double.infinity,
        height: height,
        child: image,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: resolved,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        httpHeaders: const {'User-Agent': 'Mozilla/5.0'},
        errorWidget: (context, url, error) {
          debugPrint('Image error: $error | URL: $resolved');
          return _Placeholder(height: height ?? 200);
        },
        placeholder: (context, url) =>
            _Placeholder(height: height ?? 200, loading: true),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

class _Placeholder extends StatelessWidget {
  final double height;
  final bool loading;

  const _Placeholder({required this.height, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: loading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2BBFB3),
              )
            : const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
      ),
    );
  }
}
