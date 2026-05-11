import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_sizes.dart';
import '../ui/widgets/price_marker.dart';

/// Full-screen map focused on a single property.
/// Pushed via Navigator.push from the details screen — has its own back button.
class PropertyMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final double price;
  final String address;
  final String listingType;

  const PropertyMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.price,
    required this.address,
    required this.listingType,
  });

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  late final MapController _mapController;
  bool _cardVisible = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  String get _priceLabel {
    final p = widget.price;
    if (p >= 1000000) return '\$${(p / 1000000).toStringAsFixed(1)}M';
    if (p >= 1000) return '\$${(p / 1000).toStringAsFixed(0)}K';
    return '\$${p.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ───────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15,
              onTap: (_, __) => setState(() => _cardVisible = !_cardVisible),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.habispace',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: AppSizes.w100,
                    height: AppSizes.h40,
                    child: PriceMarker(price: _priceLabel, isSelected: true),
                  ),
                ],
              ),
            ],
          ),

          // ── Back button ───────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.h12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: AppSizes.w40,
                  height: AppSizes.h40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: AppSizes.sp18,
                    color: AppColors.secondBlack,
                  ),
                ),
              ),
            ),
          ),

          // ── Property info card ────────────────────────────────────────────
          if (_cardVisible)
            Positioned(
              bottom: AppSizes.h24,
              left: AppSizes.w16,
              right: AppSizes.w16,
              child: _PropertyInfoCard(
                title: widget.title,
                address: widget.address,
                priceLabel: _priceLabel,
                listingType: widget.listingType,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PropertyInfoCard extends StatelessWidget {
  final String title;
  final String address;
  final String priceLabel;
  final String listingType;

  const _PropertyInfoCard({
    required this.title,
    required this.address,
    required this.priceLabel,
    required this.listingType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h14,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.w44,
              height: AppSizes.w44,
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.r10),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: AppColors.blue,
                size: AppSizes.sp24,
              ),
            ),
            SizedBox(width: AppSizes.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.sp14,
                      color: AppColors.secondBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.isNotEmpty) ...[
                    SizedBox(height: AppSizes.h2),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        color: AppColors.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: AppSizes.h4),
                  Row(
                    children: [
                      Text(
                        priceLabel,
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: AppSizes.sp14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (listingType.isNotEmpty) ...[
                        SizedBox(width: AppSizes.w6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.w6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: listingType.toLowerCase() == 'rent'
                                ? Colors.orange.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(AppSizes.r4),
                          ),
                          child: Text(
                            listingType,
                            style: TextStyle(
                              fontSize: AppSizes.sp10,
                              fontWeight: FontWeight.w600,
                              color: listingType.toLowerCase() == 'rent'
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
