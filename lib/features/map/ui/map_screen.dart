
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:habispace/features/map/entity/entity.dart';
import 'package:habispace/features/map/logic/map_state.dart';
import 'package:habispace/features/map/ui/widgets/price_marker.dart';
import 'package:latlong2/latlong.dart';

import '../logic/map_cubit.dart';


class MapTabView extends StatefulWidget {
  const MapTabView({super.key});

  @override
  State<MapTabView> createState() => _MapTabViewState();
}

class _MapTabViewState extends State<MapTabView>
    with AutomaticKeepAliveClientMixin {

  late final MapController _mapController;

  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => MapCubit(),
      child: _MapBody(mapController: _mapController),
    );
  }
}
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
                initialCenter: const LatLng(30.0444, 31.2357),
                initialZoom: 12,
                onTap: (_, _) => context.read<MapCubit>().clearSelection(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.habispace',
                ),
                MarkerLayer(
                  markers: state.properties.map((property) {
                    final isSelected = state.selectedProperty?.id == property.id;
                    return Marker(
                      point: LatLng(property.lat, property.lng),
                      width: 100,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          context.read<MapCubit>().selectMarker(property);
                          mapController.move(
                            LatLng(property.lat, property.lng),
                            14,
                          );
                        },
                        child: PriceMarker(
                          price: property.price,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            if (state.selectedProperty != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
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


class _PropertyCard extends StatelessWidget {
  final PropertyLocation property;
  final VoidCallback onClose;

  const _PropertyCard({required this.property, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.home, size: 36, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.price,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}