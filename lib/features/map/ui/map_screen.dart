import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:habispace/core/shared/image_shimmer.dart';
import 'package:habispace/features/home/domain/entities/home_property_entity.dart';
import 'package:habispace/features/home/presentation/cubit/home_cubit.dart';
import 'package:habispace/features/map/entity/entity.dart';
import 'package:habispace/features/map/logic/map_state.dart';
import 'package:habispace/features/map/ui/widgets/price_marker.dart';
import 'package:latlong2/latlong.dart';

import '../logic/map_cubit.dart';
import '../../../core/utils/app_sizes.dart';
import '../../../core/utils/app_color.dart';

class MapTabView extends StatefulWidget {
  const MapTabView({super.key});

  @override
  State<MapTabView> createState() => _MapTabViewState();
}

class _MapTabViewState extends State<MapTabView>
    with AutomaticKeepAliveClientMixin {
  late final MapController _mapController;
  late final MapCubit _mapCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapCubit = MapCubit();
    // Load properties from the already-fetched HomeCubit state
    _loadFromHomeCubit();
  }

  void _loadFromHomeCubit() {
    final homeState = context.read<HomeCubit>().state;
    _loadProperties(homeState);
  }

  void _loadProperties(HomeState homeState) {
    if (homeState is HomeSuccess) {
      // Merge all property lists and deduplicate by id
      final seen = <int>{};
      final all = <HomePropertyEntity>[];
      for (final p in [
        ...homeState.home.bestSelling,
        ...homeState.home.featured,
        ...homeState.home.recommended,
      ]) {
        if (seen.add(p.id)) all.add(p);
      }
      _mapCubit.loadProperties(all);
    } else if (homeState is HomeSearchSuccess) {
      _mapCubit.loadProperties(homeState.results);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _mapCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<HomeCubit, HomeState>(
      // Re-load map markers whenever home data changes
      listener: (context, homeState) => _loadProperties(homeState),
      child: BlocProvider.value(
        value: _mapCubit,
        child: _MapBody(mapController: _mapController),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MapBody extends StatelessWidget {
  final MapController mapController;
  const _MapBody({required this.mapController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: state.properties.isNotEmpty
                    ? LatLng(
                        state.properties.first.lat,
                        state.properties.first.lng,
                      )
                    : const LatLng(30.0444, 31.2357),
                initialZoom: 11,
                onTap: (_, __) => context.read<MapCubit>().clearSelection(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.habispace',
                ),
                MarkerLayer(
                  markers: state.properties.map((property) {
                    final isSelected =
                        state.selectedProperty?.id == property.id;
                    return Marker(
                      point: LatLng(property.lat, property.lng),
                      width: AppSizes.w100,
                      height: AppSizes.h40,
                      child: GestureDetector(
                        onTap: () {
                          context.read<MapCubit>().selectMarker(property);
                          mapController.move(
                            LatLng(property.lat, property.lng),
                            14,
                          );
                        },
                        child: PriceMarker(
                          price: property.priceLabel,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Loading overlay
            if (state.isLoading)
              const Center(child: CircularProgressIndicator()),

            // Empty state
            if (!state.isLoading && state.properties.isEmpty)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w24,
                    vertical: AppSizes.h16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Text(
                    'No properties found',
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      color: AppColors.secondBlack,
                    ),
                  ),
                ),
              ),

            // Property card on marker tap
            if (state.selectedProperty != null)
              Positioned(
                bottom: AppSizes.h16,
                left: AppSizes.w16,
                right: AppSizes.w16,
                child: _PropertyCard(
                  property: state.selectedProperty!,
                  onClose: () => context.read<MapCubit>().clearSelection(),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  final PropertyLocation property;
  final VoidCallback onClose;

  const _PropertyCard({required this.property, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.h12),
        child: Row(
          children: [
            // Property image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              child: SizedBox(
                width: AppSizes.w70,
                height: AppSizes.h70,
                child:
                    property.imageUrl != null && property.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: property.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ImageShimmer(),
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            SizedBox(width: AppSizes.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.sp15,
                      color: AppColors.secondBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (property.address.isNotEmpty) ...[
                    SizedBox(height: AppSizes.h4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppSizes.sp12,
                          color: AppColors.textSecondaryColor,
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            property.address,
                            style: TextStyle(
                              fontSize: AppSizes.sp12,
                              color: AppColors.textSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: AppSizes.h4),
                  Row(
                    children: [
                      Text(
                        property.priceLabel,
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: AppSizes.sp14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (property.listingType.isNotEmpty) ...[
                        SizedBox(width: AppSizes.w6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.w6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: property.listingType.toLowerCase() == 'rent'
                                ? Colors.orange.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(AppSizes.r4),
                          ),
                          child: Text(
                            property.listingType,
                            style: TextStyle(
                              fontSize: AppSizes.sp10,
                              fontWeight: FontWeight.w600,
                              color:
                                  property.listingType.toLowerCase() == 'rent'
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
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.home, size: AppSizes.sp36, color: Colors.grey),
    );
  }
}
