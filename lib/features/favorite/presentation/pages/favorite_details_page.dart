import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../favorite/domain/entities/favorite_property_entity.dart';
import '../../../home/domain/entities/home_property_entity.dart';
import '../cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../widgets/details_content.dart';
import '../widgets/details_sliver_appBar.dart';
import '../widgets/favorite_card_widget.dart';
import '../widgets/floating_back_button.dart';
import '../widgets/related_header.dart';

class FavoriteDetailsPage extends StatelessWidget {
  final FavoritePropertyEntity property;
  final List<FavoritePropertyEntity> allFavorites;

  const FavoriteDetailsPage({
    super.key,
    required this.property,
    this.allFavorites = const [],
  });

  List<FavoritePropertyEntity> _relatedProperties(
    List<FavoritePropertyEntity> currentFavorites,
  ) {
    return currentFavorites
        .where(
          (p) => p.categoryId == property.categoryId && p.id != property.id,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteLoaded) {
          final stillExists = state.favorites.any((p) => p.id == property.id);
          if (!stillExists) {
            context.pop();
          }
        }
      },
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final List<FavoritePropertyEntity> liveFavorites =
              state is FavoriteLoaded
              ? state.favorites
              : state is FavoriteRemoving
              ? state.favorites
              : allFavorites;

          final related = _relatedProperties(liveFavorites);

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    DetailsSliverAppBar(property: property),
                    SliverToBoxAdapter(
                      child: DetailsContent(property: property),
                    ),
                    if (related.isNotEmpty) ...[
                      const SliverToBoxAdapter(child: RelatedHeader()),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        sliver: SliverList.separated(
                          itemCount: related.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) => FavoriteCardWidget(
                            property: related[index],
                            onTap: () => context.pushNamed(
                              AppRoutes.details,
                              extra: {
                                'propertyId': related[index].id,
                                'favoriteCubit': context.read<FavoriteCubit>(),
                                'similarProperties': <HomePropertyEntity>[],
                              },
                            ),
                            onFavoriteTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: FloatingBackButton(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
