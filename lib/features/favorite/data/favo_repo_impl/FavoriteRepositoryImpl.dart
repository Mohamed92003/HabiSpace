
import 'package:habispace/features/favorite/domain/entities/favorite_property_entity.dart';

import '../../domain/repositories/Favorite_repository.dart';
import '../datasource/FavoriteRemoteDataSource.dart';
import '../models/favorite_property_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addFavorite(int propertyId) async {
    return await remoteDataSource.addFavorite(propertyId);
  }

  @override
  Future<void> removeFavorite(int propertyId) async {
    return await remoteDataSource.removeFavorite(propertyId);
  }

  @override
  Future<List<FavoritePropertyEntity>> getFavorites() async {
    final models = await remoteDataSource.fetchFavorites();
    return models.map((m) => m.toEntity()).toList();
  }
}
