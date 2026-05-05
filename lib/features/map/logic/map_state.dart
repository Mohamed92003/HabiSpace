import 'package:equatable/equatable.dart';

import '../entity/entity.dart';

class MapState extends Equatable {
  final List<PropertyLocation> properties;
  final PropertyLocation? selectedProperty;

  const MapState({required this.properties, this.selectedProperty});

  MapState copyWith({
    List<PropertyLocation>? properties,
    PropertyLocation? selectedProperty,
    bool clearSelected = false,
  }) {
    return MapState(
      properties: properties ?? this.properties,
      selectedProperty: clearSelected ? null : selectedProperty ?? this.selectedProperty,
    );
  }

  @override
  List<Object?> get props => [properties, selectedProperty];
}