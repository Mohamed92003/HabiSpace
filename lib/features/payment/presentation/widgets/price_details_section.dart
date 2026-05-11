import 'package:flutter/material.dart';
import 'package:habispace/core/theme/app_theme.dart';
import 'package:habispace/features/details/domain/entities/property_detail_entity.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class PriceDetailsSection extends StatelessWidget {
  final PropertyDetailEntity property;

  const PriceDetailsSection({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final housePrice = property.price;
    const serviceFee = 250.0;
    final total = housePrice + serviceFee;

    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price details',
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
              color: context.appTheme.titleText,
            ),
          ),
          SizedBox(height: AppSizes.h16),
          _PriceRow(
            title: 'House Prices',
            price: '\$${housePrice.toStringAsFixed(3)}',
          ),
          SizedBox(height: AppSizes.h8),
          _PriceRow(
            title: 'HabiSpace service fee',
            price: '\$${serviceFee.toStringAsFixed(0)}',
          ),
          SizedBox(height: AppSizes.h16),
          Divider(color: context.appTheme.divider),
          SizedBox(height: AppSizes.h8),
          _PriceRow(
            title: 'Total',
            price: '\$${total.toStringAsFixed(3)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String price;
  final bool isTotal;

  const _PriceRow({
    required this.title,
    required this.price,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? AppSizes.sp16 : AppSizes.sp14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: context.appTheme.titleText,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? AppSizes.sp16 : AppSizes.sp14,
            fontWeight: FontWeight.w600,
            color: context.appTheme.titleText,
          ),
        ),
      ],
    );
  }
}
