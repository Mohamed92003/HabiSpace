import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/features/home/domain/entities/home_property_entity.dart';
import 'package:habispace/features/map/entity/entity.dart';

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState(properties: [], isLoading: true));

  /// Converts a list of [HomePropertyEntity] into [PropertyLocation] markers,
  /// skipping any properties with invalid (zero) coordinates.
  void loadProperties(List<HomePropertyEntity> properties) {
    final locations = properties
        .where((p) => p.latitude != 0 && p.longitude != 0)
        .map(
          (p) => PropertyLocation(
            id: p.id,
            lat: p.latitude,
            lng: p.longitude,
            title: p.title,
            price: p.price,
            imageUrl: p.images.isNotEmpty ? p.images.first : null,
            address: p.address,
            listingType: p.listingType,
          ),
        )
        .toList();

    emit(state.copyWith(properties: locations, isLoading: false));
  }

  void selectMarker(PropertyLocation property) {
    emit(state.copyWith(selectedProperty: property));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelected: true));
  }
}
