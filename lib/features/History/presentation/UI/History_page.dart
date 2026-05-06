import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/core/shared/error_view.dart';
import 'package:habispace/features/History/presentation/Cubit/cubit/history_cubit.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

List<Widget> historyViewSlivers(BuildContext context, HistoryState state) {
  if (state is HistoryLoading || state is HistoryInitial) {
    return [
      const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
    ];
  }

  if (state is HistoryError) {
    return [
      SliverErrorView(
        message: state.error,
        onRetry: () => context.read<HistoryCubit>().getHistory(),
      ),
    ];
  }

  if (state is HistorySuccess) {
    final orders = state.filtered;

    if (orders.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: AppSizes.h64,
                  color: Colors.grey,
                ),
                SizedBox(height: AppSizes.h16),
                Text(
                  AppTexts.noHistoryYet.tr(),
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w12, vertical: AppSizes.h8),
        sliver: SliverList.separated(
          itemCount: orders.length,
          separatorBuilder: (_, _) => SizedBox(height: AppSizes.h4),
          itemBuilder: (context, index) {
            final order = orders[index];
            final property = order.property;

            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: AppSizes.h4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.r20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.r20),
                    ),
                    child: property.images.isNotEmpty
                        ? Image.network(
                            property.images[0],
                            width: double.infinity,
                            height: AppSizes.h180,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: AppSizes.h180,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.home,
                              color: Colors.grey,
                              size: AppSizes.sp48,
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSizes.h12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                property.title,
                                style: TextStyle(
                                  fontSize: AppSizes.sp16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _StatusBadge(status: order.status),
                          ],
                        ),
                        SizedBox(height: AppSizes.h6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppSizes.sp16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: AppSizes.w4),
                            Expanded(
                              child: Text(
                                property.address,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: AppSizes.sp12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.h10),
                        Wrap(
                          spacing: AppSizes.w12,
                          runSpacing: AppSizes.h8,
                          children: [
                            _InfoItem(
                              icon: Icons.bed,
                              text:
                                  '${property.bedrooms} Bedroom${property.bedrooms != 1 ? 's' : ''}',
                            ),
                            _InfoItem(
                              icon: Icons.bathtub,
                              text:
                                  '${property.bathrooms} Bathroom${property.bathrooms != 1 ? 's' : ''}',
                            ),
                            _InfoItem(
                              icon: Icons.category_outlined,
                              text: property.categoryName,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.h12),
                        Row(
                          children: [
                            Text(
                              '\$${order.amount}',
                              style: TextStyle(
                                fontSize: AppSizes.sp16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: AppSizes.w4),
                            Text(
                              order.currency.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: AppSizes.sp12,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: AppSizes.sp14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: AppSizes.w4),
                            Text(
                              order.createdAt.substring(0, 10),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: AppSizes.sp12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }

  return [const SliverToBoxAdapter(child: SizedBox.shrink())];
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'completed' => Colors.green,
      'pending' => Colors.orange,
      'cancelled' => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w10, vertical: AppSizes.h4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.r20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: AppSizes.sp11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.sp16, color: Colors.grey),
        SizedBox(width: AppSizes.w4),
        Text(text, style: TextStyle(fontSize: AppSizes.sp12, color: Colors.grey)),
      ],
    );
  }
}
