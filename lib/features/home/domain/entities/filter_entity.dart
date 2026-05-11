class FilterEntity {
  final String? listingType;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;

  const FilterEntity({
    this.listingType,
    this.latitude,
    this.longitude,
    this.radiusKm,
  });

  bool get isEmpty =>
      listingType == null &&
      latitude == null &&
      longitude == null &&
      radiusKm == null;
}
