// features/map/presentation/cubit/map_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/features/map/entity/entity.dart';

import 'map_state.dart';


class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapState(properties: _mockProperties));

  void selectMarker(PropertyLocation property) {
    emit(state.copyWith(selectedProperty: property));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelected: true));
  }
}

// Mock — replace with your actual repo call
const _mockProperties = [
  PropertyLocation(id: 1, lat: 30.0444, lng: 31.2357, title: 'Cairo Apartment', price: '\$120,000'),
  PropertyLocation(id: 2, lat: 30.0600, lng: 31.2500, title: 'Nasr City Villa',  price: '\$250,000'),
  PropertyLocation(id: 3, lat: 29.9800, lng: 31.1800, title: 'Giza Studio',      price: '\$75,000'),
];