import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';


abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String displayName; // e.g. "Nasr City, Cairo"
  final double latitude;
  final double longitude;

  LocationLoaded({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}


class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> fetchLocation() async {
    if (state is LocationLoading) return; // prevent duplicate calls
    emit(LocationLoading());

    final Position? position = await LocationService.getCurrentPosition();

    if (position == null) {
      emit(LocationError('Location unavailable'));
      return;
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      // Build a readable label: "Sublocality, City" or fallback to coords
      final parts = <String>[
        if (place?.subLocality != null && place!.subLocality!.isNotEmpty)
          place.subLocality!,
        if (place?.locality != null && place!.locality!.isNotEmpty)
          place.locality!,
      ];

      final displayName = parts.isNotEmpty
          ? parts.join(', ')
          : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

      emit(
        LocationLoaded(
          displayName: displayName,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (_) {
      // Geocoding failed but we still have coordinates
      emit(
        LocationLoaded(
          displayName:
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    }
  }
}
