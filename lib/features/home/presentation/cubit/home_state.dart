part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeEntity home;
  final int selectedTab;
  final List<HomePropertyEntity> filteredBestSelling;
  final List<HomePropertyEntity> filteredFeatured;
  final List<HomePropertyEntity> filteredRecommended;

  HomeSuccess({
    required this.home,
    required this.selectedTab,
    required this.filteredBestSelling,
    required this.filteredFeatured,
    required this.filteredRecommended,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeSearchLoading extends HomeState {}

class HomeSearchSuccess extends HomeState {
  final List<HomePropertyEntity> results;
  final String query;
  HomeSearchSuccess({required this.results, required this.query});
}