import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../favorite/domain/entities/favorite_property_entity.dart';
import '../cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../widgets/favorite_card_widget.dart';
import '../widgets/favorite_header_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/shared/error_view.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../../core/utils/app_sizes.dart';

List<Widget> favoriteBodySlivers(
  BuildContext context,
  FavoriteState state, {
  String? categoryFilter,
  List<FavoritePropertyEntity>? allFavorites,
}) {
  switch (state) {
    case FavoriteLoading():
      return [
        SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ];

    case FavoriteError(:final message):
      return [
        SliverErrorView(
          message: message,
          onRetry: () => context.read<FavoriteCubit>().getFavorites(),
        ),
      ];

    case FavoriteLoaded():
      return _buildCategoryGridSlivers(context: context, state: state);

    case FavoriteRemoving():
      return _buildCategoryGridSlivers(
        context: context,
        state: FavoriteLoaded(
          state.favorites,
          isEditMode: state.isEditMode,
          searchQuery: state.searchQuery,
        ),
      );

    default:
      return [const SliverToBoxAdapter(child: SizedBox.shrink())];
  }
}

List<Widget> _buildCategoryGridSlivers({
  required BuildContext context,
  required FavoriteLoaded state,
}) {
  final favorites = state.filtered;

  final grouped = <String, List<FavoritePropertyEntity>>{};
  for (final p in favorites) {
    grouped.putIfAbsent(p.categoryName, () => []).add(p);
  }
  final categories = grouped.entries.toList();

  return [
    SliverToBoxAdapter(
      child: FavoriteHeaderWidget(
        title: AppTexts.yourFavorite.tr(),
        isEditMode: state.isEditMode,
        showBackButton: false,
        onEdit: () => context.read<FavoriteCubit>().toggleEditMode(),
      ),
    ),
    if (favorites.isEmpty)
      SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: AppSizes.sp64,
                color: Colors.grey,
              ),
              SizedBox(height: AppSizes.h16),
              Text(
                AppTexts.noFavoritesYet.tr(),
                style: TextStyle(fontSize: AppSizes.sp16, color: Colors.grey),
              ),
            ],
          ),
        ),
      )
    else
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h8,
        ),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.85,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final name = categories[index].key;
            final props = categories[index].value;
            return _CategoryCard(
              categoryName: name,
              properties: props,
              allFavorites: state.favorites,
              isEditMode: state.isEditMode,
            );
          }, childCount: categories.length),
        ),
      ),
  ];
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final List<FavoritePropertyEntity> properties;
  final List<FavoritePropertyEntity> allFavorites;
  final bool isEditMode;

  const _CategoryCard({
    required this.categoryName,
    required this.properties,
    required this.allFavorites,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditMode
          ? null
          : () => context.pushNamed(
              AppRoutes.favoriteBody,
              extra: {
                'favoriteCubit': context.read<FavoriteCubit>(),
                'categoryFilter': categoryName,
              },
            ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.r14),
                  child: _ImageGrid(properties: properties),
                ),
              ),
              SizedBox(height: AppSizes.h8),
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: AppSizes.sp15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.h2),
              Text(
                '${properties.length} ${properties.length == 1 ? 'property' : 'properties'}',
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (isEditMode)
            Positioned(
              top: -5,
              left: -4,
              child: GestureDetector(
                onTap: () {
                  final cubit = context.read<FavoriteCubit>();
                  for (final p in properties) {
                    cubit.removeFavorite(p.id);
                  }
                },
                child: Container(
                  width: AppSizes.w28,
                  height: AppSizes.h28,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: AppSizes.sp18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<FavoritePropertyEntity> properties;
  const _ImageGrid({required this.properties});

  List<String?> _slots() {
    final urls = <String?>[];
    for (final p in properties) {
      urls.add(p.images.isNotEmpty ? p.images.first : null);
      if (urls.length == 4) return urls;
    }
    while (urls.length < 4) urls.add(null);
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final slots = _slots();
    final realCount = slots.where((s) => s != null).length;

    if (realCount == 1) {
      return _Tile(url: slots[0]);
    }

    if (realCount == 2) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _Tile(url: slots[0])),
                SizedBox(width: AppSizes.w2),
                Expanded(child: _Tile(url: slots[1])),
              ],
            ),
          ),
          SizedBox(height: AppSizes.h2),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _Tile(url: null)),
                SizedBox(width: AppSizes.w2),
                Expanded(child: _Tile(url: null)),
              ],
            ),
          ),
        ],
      );
    }

    if (realCount == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _Tile(url: slots[0])),
                SizedBox(width: AppSizes.w2),
                Expanded(child: _Tile(url: slots[1])),
              ],
            ),
          ),
          SizedBox(height: AppSizes.h2),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _Tile(url: slots[2])),
                SizedBox(width: AppSizes.w2),
                Expanded(child: _Tile(url: null)),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Tile(url: slots[0])),
              SizedBox(width: AppSizes.w2),
              Expanded(child: _Tile(url: slots[1])),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Tile(url: slots[2])),
              SizedBox(width: AppSizes.w2),
              Expanded(child: _Tile(url: slots[3])),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String? url;
  const _Tile({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Container(
        color: Colors.grey.shade100,
        child: Center(
          child: Icon(
            Icons.home_outlined,
            color: Colors.grey,
            size: AppSizes.sp28,
          ),
        ),
      );
    }
    return SizedBox.expand(
      child: CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(
          color: Colors.grey.shade100,
          child: Center(
            child: Icon(
              Icons.home_outlined,
              color: Colors.grey,
              size: AppSizes.sp28,
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteBody extends StatelessWidget {
  final String? categoryFilter;
  final List<FavoritePropertyEntity>? allFavorites;

  const FavoriteBody({super.key, this.categoryFilter, this.allFavorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          buildWhen: (prev, curr) {
            final prevList = prev is FavoriteLoaded
                ? prev.favorites
                : prev is FavoriteRemoving
                ? prev.favorites
                : <FavoritePropertyEntity>[];
            final currList = curr is FavoriteLoaded
                ? curr.favorites
                : curr is FavoriteRemoving
                ? curr.favorites
                : <FavoritePropertyEntity>[];
            final prevEdit = prev is FavoriteLoaded ? prev.isEditMode : false;
            final currEdit = curr is FavoriteLoaded ? curr.isEditMode : false;
            return prevList.length != currList.length || prevEdit != currEdit;
          },
          builder: (context, state) {
            final List<FavoritePropertyEntity> liveFavorites;
            final bool isEditMode;

            if (state is FavoriteLoaded) {
              liveFavorites = state.favorites;
              isEditMode = state.isEditMode;
            } else if (state is FavoriteRemoving) {
              liveFavorites = state.favorites;
              isEditMode = state.isEditMode;
            } else {
              liveFavorites = [];
              isEditMode = false;
            }

            final displayed = categoryFilter != null
                ? liveFavorites
                      .where((p) => p.categoryName == categoryFilter)
                      .toList()
                : liveFavorites;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FavoriteHeaderWidget(
                    title: categoryFilter ?? AppTexts.yourFavorite.tr(),
                    isEditMode: isEditMode,
                    onEdit: () =>
                        context.read<FavoriteCubit>().toggleEditMode(),
                  ),
                ),
                if (displayed.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        AppTexts.noFavoritesYet.tr(),
                        style: TextStyle(
                          fontSize: AppSizes.sp16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w16,
                      vertical: AppSizes.h12,
                    ),
                    sliver: SliverList.separated(
                      itemCount: displayed.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppSizes.h16),
                      itemBuilder: (context, index) {
                        final property = displayed[index];
                        return _EditableCard(
                          key: ValueKey(property.id),
                          property: property,
                          isEditMode: isEditMode,
                          allFavorites: liveFavorites,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EditableCard extends StatelessWidget {
  final FavoritePropertyEntity property;
  final bool isEditMode;
  final List<FavoritePropertyEntity> allFavorites;

  const _EditableCard({
    super.key,
    required this.property,
    required this.isEditMode,
    required this.allFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      buildWhen: (prev, curr) {
        final wasRemoving =
            prev is FavoriteRemoving && prev.removingId == property.id;
        final isRemoving =
            curr is FavoriteRemoving && curr.removingId == property.id;
        return wasRemoving != isRemoving;
      },
      builder: (context, state) {
        final isRemoving =
            state is FavoriteRemoving && state.removingId == property.id;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedOpacity(
              opacity: isRemoving ? 0.4 : 1.0,
              duration: Duration(milliseconds: 200),
              child: FavoriteCardWidget(
                property: property,
                onTap: isEditMode
                    ? null
                    : () => context.pushNamed(
                        AppRoutes.favoriteDetails,
                        extra: {
                          'favoriteCubit': context.read<FavoriteCubit>(),
                          'property': property,
                          'allFavorites': allFavorites,
                        },
                      ),
                onFavoriteTap: () {},
              ),
            ),
            if (isEditMode)
              Positioned(
                top: -8,
                left: -8,
                child: GestureDetector(
                  onTap: isRemoving
                      ? null
                      : () => context.read<FavoriteCubit>().removeFavorite(
                          property.id,
                        ),
                  child: Container(
                    width: AppSizes.w28,
                    height: AppSizes.h28,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: isRemoving
                        ? Padding(
                            padding: EdgeInsets.all(AppSizes.h6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: AppSizes.sp18,
                          ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
