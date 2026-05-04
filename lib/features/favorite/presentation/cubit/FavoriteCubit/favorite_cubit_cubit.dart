import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:habispace/core/error/app_exception.dart';
import '../../../../favorite/domain/entities/favorite_property_entity.dart';
import '../../../../favorite/domain/useCases/Add_to_favourite.dart';
import '../../../../favorite/domain/useCases/Get_list_favourite.dart';
import '../../../../favorite/domain/useCases/Remove_favourite.dart';
import 'favorite_cubit_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetListFavoriteUseCase getListFavoriteUseCase;
  final AddToFavouriteUseCase addToFavouriteUseCase;
  final RemoveFavouriteUseCase removeFavouriteUseCase;

  final Set<int> _pendingAddIds = {};
  final Set<int> _confirmedAddIds = {};

  FavoriteCubit({
    required this.getListFavoriteUseCase,
    required this.addToFavouriteUseCase,
    required this.removeFavouriteUseCase,
  }) : super(FavoriteInitial());

  Future<void> getFavorites() async {
    if (isClosed) return;
    emit(FavoriteLoading());
    try {
      final favorites = await getListFavoriteUseCase.call();

      _pendingAddIds.clear();
      _confirmedAddIds.clear();
      if (isClosed) return;
      emit(FavoriteLoaded(favorites));
    } catch (e, st) {
      debugPrint('❌ FavoriteCubit.getFavorites error: $e\n$st');
      if (isClosed) return;
      emit(FavoriteError(handleException(e).message));
    }
  }

  Future<void> addFavorite(int propertyId) async {
    final current = state;

    _pendingAddIds.add(propertyId);
    if (current is FavoriteLoaded) {
      if (isClosed) return;
      emit(current.copyWith(
        pendingFavoriteIds: {..._pendingAddIds, ..._confirmedAddIds},
      ));
    }

    try {
      await addToFavouriteUseCase.call(propertyId);

      _pendingAddIds.remove(propertyId);
      _confirmedAddIds.add(propertyId);

      final favorites = await getListFavoriteUseCase.call();
      _pendingAddIds.clear();
      _confirmedAddIds.clear();
      final curr = state;
      if (isClosed) return;
      emit(FavoriteLoaded(
        favorites,
        isEditMode: curr is FavoriteLoaded ? curr.isEditMode : false,
        searchQuery: curr is FavoriteLoaded ? curr.searchQuery : '',
      ));
    } catch (e) {
      _pendingAddIds.remove(propertyId);
      _confirmedAddIds.remove(propertyId);
      final curr = state;
      if (isClosed) return;
      if (curr is FavoriteLoaded) {
        emit(curr.copyWith(
          pendingFavoriteIds: {..._pendingAddIds, ..._confirmedAddIds},
        ));
      }
      debugPrint('❌ FavoriteCubit.addFavorite error: $e');
    }
  }

  bool isFavorite(int propertyId) {
    if (_pendingAddIds.contains(propertyId)) return true;
    final current = state;
    if (current is FavoriteLoaded) {
      return current.favorites.any((p) => p.id == propertyId);
    }
    return false;
  }

  void search(String query) {
    final current = state;
    if (current is FavoriteLoaded) {
      emit(current.copyWith(searchQuery: query));
    }
  }

  void toggleEditMode() {
    final current = state;
    if (current is FavoriteLoaded) {
      emit(current.copyWith(isEditMode: !current.isEditMode));
    }
  }

  Future<void> removeFavorite(int propertyId) async {
    final current = state;
    if (current is! FavoriteLoaded) return;

    _pendingAddIds.remove(propertyId);
    _confirmedAddIds.remove(propertyId);

    final currentList = List<FavoritePropertyEntity>.from(current.favorites);
    final updated = currentList.where((p) => p.id != propertyId).toList();
    final wasEditMode = current.isEditMode;

    if (isClosed) return;
    emit(FavoriteRemoving(
      currentList,
      propertyId,
      isEditMode: wasEditMode,
      searchQuery: current.searchQuery,
    ));

    try {
      await removeFavouriteUseCase.call(propertyId);
      if (isClosed) return;
      emit(FavoriteLoaded(
        updated,
        isEditMode: wasEditMode,
        searchQuery: current.searchQuery,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(FavoriteLoaded(
        currentList,
        isEditMode: wasEditMode,
        searchQuery: current.searchQuery,
      ));
    }
  }
}
