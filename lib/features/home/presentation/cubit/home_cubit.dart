import 'package:bloc/bloc.dart';
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
      // Fetch home data and all properties ratings in parallel
      final homeResult = await getHomeUseCase();

      // Silently fetch ratings from the properties endpoint which always
      // includes the rating field, then patch the home lists
      final success = await _buildSuccessWithRatings(homeResult);
      _lastSuccess = success;
      emit(success);
    } catch (e) {
      emit(HomeError(handleException(e).message));
    }
  }

  /// Fetches all properties from the /properties endpoint (which includes
  /// ratings) and merges the ratings into the home entity lists.
  Future<HomeSuccess> _buildSuccessWithRatings(HomeEntity home) async {
    try {
      if (home.bestSelling.isEmpty &&
          home.featured.isEmpty &&
          home.recommended.isEmpty) {
        return HomeSuccess(
          home: home,
          selectedTab: 0,
          filteredBestSelling: home.bestSelling,
          filteredFeatured: home.featured,
          filteredRecommended: home.recommended,
        );
      }

      // Fetch all properties with ratings using the filter endpoint
      // (no params = returns all properties, always includes rating field)
      final ratedProps = await filterPropertiesUseCase(const FilterEntity());
      final ratingMap = <int, double?>{};
      final countMap = <int, int>{};
      for (final p in ratedProps) {
        ratingMap[p.id] = p.rating;
        countMap[p.id] = p.reviewsCount;
      }

      // Patch ratings into home lists
      List<HomePropertyEntity> patch(List<HomePropertyEntity> list) =>
          list.map((p) {
            final r = ratingMap[p.id];
            final c = countMap[p.id] ?? p.reviewsCount;
            return (r != null && r > 0) ? p.copyWithRating(r, c) : p;
          }).toList();

      final patched = HomeEntity(
        categories: home.categories,
        bestSelling: patch(home.bestSelling),
        featured: patch(home.featured),
        recommended: patch(home.recommended),
      );

      return HomeSuccess(
        home: patched,
        selectedTab: 0,
        filteredBestSelling: patched.bestSelling,
        filteredFeatured: patched.featured,
        filteredRecommended: patched.recommended,
      );
    } catch (_) {
      // If rating fetch fails, just show home data without ratings
      return HomeSuccess(
        home: home,
        selectedTab: 0,
        filteredBestSelling: home.bestSelling,
        filteredFeatured: home.featured,
        filteredRecommended: home.recommended,
      );
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

  /// Called when returning from the details screen — patches the rating
  /// of a specific property in the home lists without a full reload.
  void updatePropertyRating(int propertyId, double rating, int reviewsCount) {
    final current = state;
    if (current is! HomeSuccess) return;

    List<HomePropertyEntity> patch(List<HomePropertyEntity> list) => list
        .map(
          (p) =>
              p.id == propertyId ? p.copyWithRating(rating, reviewsCount) : p,
        )
        .toList();

    final updatedHome = HomeEntity(
      categories: current.home.categories,
      bestSelling: patch(current.home.bestSelling),
      featured: patch(current.home.featured),
      recommended: patch(current.home.recommended),
    );

    final s = HomeSuccess(
      home: updatedHome,
      selectedTab: current.selectedTab,
      filteredBestSelling: patch(current.filteredBestSelling),
      filteredFeatured: patch(current.filteredFeatured),
      filteredRecommended: patch(current.filteredRecommended),
    );
    _lastSuccess = s;
    emit(s);
  }
}
