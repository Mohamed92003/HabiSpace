import '../entities/filter_entity.dart';
import '../entities/home_entity.dart';
import '../entities/home_property_entity.dart';

abstract class HomeRepo {
  Future<HomeEntity> getHome();
  Future<List<HomePropertyEntity>> searchProperties(String query);
  Future<List<HomePropertyEntity>> filterProperties(FilterEntity filter);

}