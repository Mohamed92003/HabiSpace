import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habispace/features/map/ui/map_screen.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../../favorite/presentation/pages/favoriteMainPage.dart';
import '../../../History/presentation/Cubit/cubit/history_cubit.dart';
import '../../../History/presentation/UI/History_page.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../home/presentation/ui/home_view.dart';
import '../../../profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../profile/presentation/UI/Profile_screen.dart';
import '../../../profile/presentation/widgets/profile_avatar.dart';
import '../widgets/header.dart';
import '../widgets/home_header_delegate.dart';
import '../../../../core/utils/app_sizes.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  static const List<String> _icons = [
    "assets/icons/home_icon.svg",
    "assets/icons/favo_icon.svg",
    "assets/icons/map_icon.svg",
    "assets/icons/histo_icon.svg",
    "assets/icons/locat_icon.svg",
  ];

  List<String> get _labels => [
    AppTexts.navHome.tr(),
    AppTexts.navFavourites.tr(),
    AppTexts.navMap.tr(),
    AppTexts.navHistory.tr(),
    AppTexts.navProfile.tr(),
  ];

  List<String> get _searchHints => [
    AppTexts.searchHomeHint.tr(),
    AppTexts.searchFavoritesHint.tr(),
    AppTexts.searchOnMapHint.tr(),
    AppTexts.searchHistoryHint.tr(),
    AppTexts.searchProfileHint.tr(),
  ];

  void onTap(int index) {
    final homeCubit = context.read<HomeCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();

    if (index != currentIndex) {
      _searchController.clear();
      if (currentIndex == 0) homeCubit.searchProperties('');
      if (currentIndex == 1) favoriteCubit.search('');
      if (currentIndex == 3) context.read<HistoryCubit>().search('');
    }

    setState(() => currentIndex = index);

    if (index == 3 && context.read<HistoryCubit>().state is HistoryInitial) {
      context.read<HistoryCubit>().getHistory();
    }
    if (index == 4 && context.read<ProfileCubit>().state is ProfileInitial) {
      context.read<ProfileCubit>().getProfile();
    }
  }

  Widget _buildIcon(String asset, bool isActive) {
    return SvgPicture.asset(
      asset,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        BlendMode.srcIn,
      ),
    );
  }

  List<Widget> _buildSlivers(
    BuildContext context,
    HomeState homeState,
    FavoriteState favoriteState,
    HistoryState historyState,
    ProfileState profileState,
  ) {
    final homeCubit = context.read<HomeCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();

    if (currentIndex == 4) {
      return profileViewSlivers(context, profileState);
    }

    final sharedHeader = <Widget>[
      const SliverToBoxAdapter(child: Header()),
      SliverPersistentHeader(
        pinned: true,
        delegate: HomeHeaderDelegate(
          searchController: _searchController,
          hint: _searchHints[currentIndex.clamp(0, _searchHints.length - 1)],
          showFilter: currentIndex == 0,
          onSearch: (query) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 400), () {
              if (currentIndex == 1) {
                favoriteCubit.search(query);
              } else if (currentIndex == 3) {
                context.read<HistoryCubit>().search(query);
              } else {
                homeCubit.searchProperties(query);
              }
            });
          },
        ),
      ),
    ];

    switch (currentIndex) {
      case 1:
        return [
          ...sharedHeader,
          ...favoriteBodySlivers(context, favoriteState),
        ];
      case 3:
        return [...sharedHeader, ...historyViewSlivers(context, historyState)];
      default:
        return [
          ...sharedHeader,
          ...homeViewSlivers(context, homeState, favoriteCubit),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, homeState) {
        return BlocBuilder<FavoriteCubit, FavoriteState>(
          buildWhen: (prev, curr) => prev != curr,
          builder: (context, favoriteState) {
            return BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, historyState) {
                return BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    return GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Scaffold(
                        backgroundColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor,
                        body: Stack(
                          children: [
                            SafeArea(
                              child: Offstage(
                                offstage: currentIndex != 2,
                                child: const MapTabView(),
                              ),
                            ),

                            if (currentIndex != 2)
                              currentIndex == 4
                                  ? CustomScrollView(
                                      slivers: _buildSlivers(
                                        context,
                                        homeState,
                                        favoriteState,
                                        historyState,
                                        profileState,
                                      ),
                                    )
                                  : SafeArea(
                                      child: CustomScrollView(
                                        slivers: _buildSlivers(
                                          context,
                                          homeState,
                                          favoriteState,
                                          historyState,
                                          profileState,
                                        ),
                                      ),
                                    ),
                          ],
                        ),
                        bottomNavigationBar: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: BottomNavigationBar(
                            currentIndex: currentIndex,
                            onTap: onTap,
                            type: BottomNavigationBarType.fixed,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            selectedItemColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            unselectedItemColor: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            selectedLabelStyle: TextStyle(
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            showSelectedLabels: true,
                            showUnselectedLabels: false,
                            items: List.generate(_icons.length, (index) {
                              if (index == 4) {
                                final isActive = currentIndex == 4;
                                final user =
                                    profileState is ProfileLoaded &&
                                        profileState.profile.isNotEmpty
                                    ? profileState.profile.first
                                    : null;
                                return BottomNavigationBarItem(
                                  label: _labels[index],
                                  icon: ProfileAvatar(
                                    imageUrl: user?.image,
                                    name: user?.name ?? '',
                                    radius: 14,
                                    isActive: isActive,
                                    showBorder: true,
                                  ),
                                );
                              }
                              return BottomNavigationBarItem(
                                icon: _buildIcon(
                                  _icons[index],
                                  currentIndex == index,
                                ),
                                label: _labels[index],
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
