import 'package:equatable/equatable.dart';

import '../../../../favorite/domain/entities/favorite_property_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
  @override
  List<Object?> get props => [];
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
  @override
  List<Object?> get props => [];
}

class FavoriteLoaded extends FavoriteState {
  final List<FavoritePropertyEntity> favorites;
  final bool isEditMode;
  final String searchQuery;
  final Set<int> pendingFavoriteIds;

  const FavoriteLoaded(
    this.favorites, {
    this.isEditMode = false,
    this.searchQuery = '',
    this.pendingFavoriteIds = const {},
  });

  bool isFavorite(int id) =>
      pendingFavoriteIds.contains(id) || favorites.any((p) => p.id == id);

  List<FavoritePropertyEntity> get filtered {
    if (searchQuery.trim().isEmpty) return favorites;
    final q = searchQuery.toLowerCase();
    return favorites.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.categoryName.toLowerCase().contains(q) ||
          p.address.toLowerCase().contains(q);
    }).toList();
  }

  FavoriteLoaded copyWith({
    List<FavoritePropertyEntity>? favorites,
    bool? isEditMode,
    String? searchQuery,
    Set<int>? pendingFavoriteIds,
  }) {
    return FavoriteLoaded(
      favorites ?? this.favorites,
      isEditMode: isEditMode ?? this.isEditMode,
      searchQuery: searchQuery ?? this.searchQuery,
      pendingFavoriteIds: pendingFavoriteIds ?? this.pendingFavoriteIds,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    isEditMode,
    searchQuery,
    pendingFavoriteIds,
  ];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteRemoving extends FavoriteState {
  final List<FavoritePropertyEntity> favorites;
  final int removingId;
  final bool isEditMode;
  final String searchQuery;

  const FavoriteRemoving(
    this.favorites,
    this.removingId, {
    this.isEditMode = false,
    this.searchQuery = '',
  });

  List<FavoritePropertyEntity> get filtered {
    if (searchQuery.trim().isEmpty) return favorites;
    final q = searchQuery.toLowerCase();
    return favorites.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.categoryName.toLowerCase().contains(q) ||
          p.address.toLowerCase().contains(q);
    }).toList();
  }

  @override
  List<Object?> get props => [favorites, removingId, isEditMode, searchQuery];
}
