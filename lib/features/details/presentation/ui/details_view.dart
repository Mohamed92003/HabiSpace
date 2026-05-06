import 'dart:ui';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../home/domain/entities/home_property_entity.dart';
import '../../domain/entities/property_detail_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../cubit/details_cubit.dart';
import '../widgets/details_app_bar.dart';
import '../widgets/details_bottom_bar.dart';
import '../widgets/details_description.dart';
import '../widgets/details_feature_grid.dart';
import '../widgets/details_hero.dart';
import '../widgets/details_listing_agent.dart';
import '../widgets/details_location_map.dart';
import '../widgets/details_price_row.dart';
import '../widgets/details_reviews_section.dart';
import '../widgets/details_you_must_also_like.dart';

class DetailsView extends StatefulWidget {
  final int propertyId;
  final List<HomePropertyEntity> similarProperties;
  const DetailsView({
    super.key,
    required this.propertyId,
    this.similarProperties = const [],
  });

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final ScrollController _scrollController = ScrollController();
  double _scrollFraction = 0.0;

  static final double _heroHeight = AppSizes.h400;
  static final double _transitionStart = AppSizes.w120;

  @override
  void initState() {
    _initDeepLinks();
    _scrollController.addListener(_onScroll);
    context.read<DetailsCubit>().loadDetails(widget.propertyId);
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DetailsCubit>().loadDetails(widget.propertyId);
  }

  void _onScroll() {
    final fraction =
        ((_scrollController.offset - _transitionStart) /
                (_heroHeight - _transitionStart))
            .clamp(0.0, 1.0);
    if (fraction != _scrollFraction) {
      setState(() => _scrollFraction = fraction);
    }
  }
late AppLinks _appLinks;
void _initDeepLinks() async {
  _appLinks = AppLinks();

  // 🔹 لو التطبيق اتفتح من لينك وهو مقفول
  final uri = await _appLinks.getInitialLink();
  if (uri != null) {
    _handleLink(uri);
  }

  // 🔹 لو التطبيق شغال وجاله لينك
  _appLinks.uriLinkStream.listen((uri) {
    if (uri != null) {
      _handleLink(uri);
    }
  });
}
 void _handleLink(Uri uri) {
  // مثال: /details/slug
  if (uri.pathSegments.contains('details')) {
    final slug = uri.pathSegments.last;

     Navigator.push(context,MaterialPageRoute(builder: (context){
      return DetailsView(propertyId:widget.propertyId);
     }));
  }
} 

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Color get _appBarBg {
    if (_scrollFraction == 0) return Colors.transparent;
    return Color.lerp(
      Colors.white.withValues(alpha: 0.12),
      Colors.white,
      _scrollFraction,
    )!;
  }

  Color get _iconColor =>
      Color.lerp(Colors.white, AppColors.secondBlack, _scrollFraction)!;

  double get _blurAmount => (1 - _scrollFraction) * 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state is DetailsLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.blue),
                )
              else if (state is DetailsError)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                        ),
                        onPressed: () => context
                            .read<DetailsCubit>()
                            .loadDetails(widget.propertyId),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              else if (state is DetailsLoaded)
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: DetailsHero(
                        property: state.property,
                        heroHeight: _heroHeight,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _DetailsContentCard(
                        property: state.property,
                        reviews: state.reviews,
                        similarProperties: widget.similarProperties,
                      ),
                    ),
                  ],
                ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DetailsAppBar(
                  blurAmount: _blurAmount,
                  bgColor: _appBarBg,
                  iconColor: _iconColor,
                  isGlass: _scrollFraction < 0.5,
                  property: state is DetailsLoaded ? state.property : null,
                ),
              ),

              if (state is DetailsLoaded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DetailsBottomBar(
                    property: state.property
                     ,),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsContentCard extends StatelessWidget {
  final PropertyDetailEntity property;
  final List<ReviewEntity> reviews;
  final List<HomePropertyEntity> similarProperties;

  const _DetailsContentCard({
    required this.property,
    required this.reviews,
    required this.similarProperties,
  });

  String _formatPrice(double price) {
    final parts = price.toInt().toString().split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h16),
            DetailsPriceRow(
              property: property,
              priceFormatted: _formatPrice(property.price),
            ),
            SizedBox(height: AppSizes.h16),
            DetailsFeatureGrid(property: property),
            SizedBox(height: AppSizes.h16),

            DetailsDescription(property: property),
            SizedBox(height: AppSizes.h16),

            DetailsListingAgent(property: property),
            SizedBox(height: AppSizes.h16),

            DetailsLocationMap(property: property),
            DetailsReviewsSection(
              reviews: reviews,
              images: property.images,
              propertyId: property.id,
            ),
            if (similarProperties.isNotEmpty) ...[
              SizedBox(height: AppSizes.h16),
              DetailsYouMustAlsoLike(properties: similarProperties),
            ],
          ],
        ),
      ),
    );
  }
}
