import 'package:flutter/material.dart';
import 'package:habispace/features/details/domain/entities/property_detail_entity.dart';
import 'package:habispace/core/utils/app_color.dart';
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
        color: Colors.white,
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
              color: AppColors.black,
            ),
          ),
          
          SizedBox(height: AppSizes.h16),
          
          _buildPriceRow('House Prices', '\$${housePrice.toStringAsFixed(3)}'),
          
          SizedBox(height: AppSizes.h8),
          
          _buildPriceRow('HabiSpace service fee', '\$${serviceFee.toStringAsFixed(0)}'),
          
          SizedBox(height: AppSizes.h16),
          
          Divider(color: Colors.grey.shade300),
          
          SizedBox(height: AppSizes.h8),
          
          _buildPriceRow(
            'Total',
            '\$${total.toStringAsFixed(3)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? AppSizes.sp16 : AppSizes.sp14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? AppSizes.sp16 : AppSizes.sp14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
