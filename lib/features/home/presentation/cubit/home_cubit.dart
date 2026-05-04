import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/home_property_entity.dart';
import '../../domain/useCases/filter_properties_usecase.dart';
import '../../domain/useCases/get_home_usecase.dart';
import '../../domain/useCases/search_properties_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeUseCase getHomeUseCase;
  final SearchPropertiesUseCase searchPropertiesUseCase;
  final FilterPropertiesUseCase filterPropertiesUseCase;

  HomeCubit(
    this.getHomeUseCase,
    this.searchPropertiesUseCase,
    this.filterPropertiesUseCase,
  ) : super(HomeInitial());

  FilterEntity _activeFilter = const FilterEntity();
  FilterEntity get activeFilter => _activeFilter;

  HomeSuccess? _lastSuccess;
  int _searchGeneration = 0;

  Future<void> getHome() async {
    emit(HomeLoading());
    try {
      final home = await getHomeUseCase();
      final success = HomeSuccess(
        home: home,
        selectedTab: 0,
        filteredBestSelling: home.bestSelling,
        filteredFeatured: home.featured,
        filteredRecommended: home.recommended,
      );
      _lastSuccess = success;
      emit(success);
    } catch (e) {
      emit(HomeError(handleException(e).message));
    }
  }

  void filterByCategory(int tabIndex) {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    final home = currentState.home;

    if (tabIndex == 0) {
      final s = HomeSuccess(
        home: home,
        selectedTab: 0,
        filteredBestSelling: home.bestSelling,
        filteredFeatured: home.featured,
        filteredRecommended: home.recommended,
      );
      _lastSuccess = s;
      emit(s);
      return;
    }

    final selectedCategory = home.categories[tabIndex - 1];

    List<HomePropertyEntity> filter(List<HomePropertyEntity> list) {
      return list.where((p) => p.category.id == selectedCategory.id).toList();
    }

    final s = HomeSuccess(
      home: home,
      selectedTab: tabIndex,
      filteredBestSelling: filter(home.bestSelling),
      filteredFeatured: filter(home.featured),
      filteredRecommended: filter(home.recommended),
    );

    _lastSuccess = s;
    emit(s);
  }

  Future<void> searchProperties(String query) async {
    if (state is HomeSuccess) {
      _lastSuccess = state as HomeSuccess;
    }

    if (query.trim().isEmpty) {
      _searchGeneration++;
      if (_lastSuccess != null) {
        emit(_lastSuccess!);
      } else {
        await getHome();
      }
      return;
    }

    final generation = ++_searchGeneration;

    try {
      final results = await searchPropertiesUseCase(query);
      if (generation == _searchGeneration) {
        emit(HomeSearchSuccess(results: results, query: query));
      }
    } catch (e) {
      if (generation == _searchGeneration) {
        emit(HomeError(handleException(e).message));
      }
    }
  }

  Future<void> applyFilter(FilterEntity filter) async {
    _activeFilter = filter;
    emit(HomeLoading());
    try {
      final results = await filterPropertiesUseCase(filter);
      emit(HomeSearchSuccess(results: results, query: ''));
    } catch (e) {
      emit(HomeError(handleException(e).message));
    }
  }

  void clearFilter() {
    _activeFilter = const FilterEntity();
    getHome();
  }
}