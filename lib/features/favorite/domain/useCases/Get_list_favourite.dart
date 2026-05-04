
import '../entities/favorite_property_entity.dart';
import '../repositories/Favorite_repository.dart';

class GetListFavoriteUseCase {
  final FavoriteRepository repository;

  GetListFavoriteUseCase(this.repository);

  Future<List<FavoritePropertyEntity>> call() async {
    return await repository.getFavorites();
  }
}
