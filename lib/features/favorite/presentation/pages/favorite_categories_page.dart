import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorite/domain/entities/favorite_property_entity.dart';
import '../cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../widgets/property_image_widget.dart';
import '../../../../core/utils/app_texts.dart';
import 'favoriteMainPage.dart';
import '../../../../core/utils/app_sizes.dart';

class FavoriteCategoriesPage extends StatelessWidget {
  const FavoriteCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            );
          }
          if (state is FavoriteError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<FavoriteCubit>().getFavorites(),
            );
          }
          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) return const _EmptyView();
            if (state.filtered.isEmpty) return const _NoResultsView();
            return _CategoriesContent(
              favorites: state.filtered,
              allFavorites: state.favorites,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  final List<FavoritePropertyEntity> favorites;
  final List<FavoritePropertyEntity> allFavorites;

  const _CategoriesContent({
    required this.favorites,
    required this.allFavorites,
  });

  Map<String, List<FavoritePropertyEntity>> _groupByCategory() {
    final map = <String, List<FavoritePropertyEntity>>{};
    for (final p in favorites) {
      map.putIfAbsent(p.categoryName, () => []).add(p);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCategory();
    final categories = grouped.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PageHeader(),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final name = categories[index].key;
              final properties = categories[index].value;
              return _CategoryCard(
                categoryName: name,
                properties: properties,
                allFavorites: allFavorites,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppTexts.yourFavorite.tr(),
            style: TextStyle(
              fontSize: AppSizes.sp22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppTexts.edit.tr(),
              style: TextStyle(
                fontSize: AppSizes.sp15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final List<FavoritePropertyEntity> properties;
  final List<FavoritePropertyEntity> allFavorites;

  const _CategoryCard({
    required this.categoryName,
    required this.properties,
    required this.allFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<FavoriteCubit>(),
            child: FavoriteBody(
              categoryFilter: categoryName,
              allFavorites: allFavorites,
            ),
          ),
        ),
      ),
      child: Column(
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
            '${properties.length} ${properties.length == 1 ? AppTexts.propertySingularKey.tr() : AppTexts.propertyPluralKey.tr()}',
            style: TextStyle(fontSize: AppSizes.sp12, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
      for (final img in p.images) {
        urls.add(img);
        if (urls.length == 4) return urls;
      }
    }
    while (urls.length < 4) {
      urls.add(null);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final slots = _slots();

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
    return PropertyImageWidget(
      imageUrl: url,
      borderRadius: BorderRadius.zero,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.h24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: AppSizes.sp48, color: Colors.red),
            SizedBox(height: AppSizes.h12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(height: AppSizes.h16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppTexts.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: AppSizes.sp64, color: Colors.grey),
          SizedBox(height: AppSizes.h16),
          Text(
            AppTexts.noFavoritesYet.tr(),
            style: TextStyle(fontSize: AppSizes.sp16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: AppSizes.sp64, color: Colors.grey),
          SizedBox(height: AppSizes.h16),
          Text(
            AppTexts.noResultsFound.tr(),
            style: TextStyle(fontSize: AppSizes.sp16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
