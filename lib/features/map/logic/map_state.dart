import 'package:equatable/equatable.dart';

import '../entity/entity.dart';

class MapState extends Equatable {
  final List<PropertyLocation> properties;
  final PropertyLocation? selectedProperty;
  final bool isLoading;

  const MapState({
    required this.properties,
    this.selectedProperty,
    this.isLoading = false,
  });

  MapState copyWith({
    List<PropertyLocation>? properties,
    PropertyLocation? selectedProperty,
    bool clearSelected = false,
    bool? isLoading,
  }) {
    return MapState(
      properties: properties ?? this.properties,
      selectedProperty: clearSelected
          ? null
          : selectedProperty ?? this.selectedProperty,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [properties, selectedProperty, isLoading];
}
