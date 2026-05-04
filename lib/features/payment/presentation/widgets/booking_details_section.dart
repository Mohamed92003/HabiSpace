import 'package:flutter/material.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_sizes.dart';
 
class BookingDetailsSection extends StatelessWidget {
  final DateTime? selectedDate;
  final int personCount;
  final VoidCallback? onEditDate;
  final VoidCallback? onEditPerson;

  const BookingDetailsSection({
    super.key,
    this.selectedDate,
    this.personCount = 4,
    this.onEditDate,
    this.onEditPerson,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null
        ? '${selectedDate!.day} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year} - 09:00'
        : '12 September 2025 - 09:00';

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
            'Booking Detail',
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          
          SizedBox(height: AppSizes.h16),
          
          _buildDetailRow(
            'Book Appointment',
            dateText,
            hasEdit: true,
            onEdit: onEditDate,
          ),
          
          SizedBox(height: AppSizes.h12),
          
          _buildDetailRow(
            'Person',
            '$personCount person${personCount > 1 ? 's' : ''}',
            hasEdit: true,
            onEdit: onEditPerson,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String title, 
    String value, {
    bool hasEdit = false,
    VoidCallback? onEdit,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppSizes.r16,
          backgroundColor: AppColors.blue,
          child: Text(
            'M',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSizes.sp14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        SizedBox(width: AppSizes.w12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: AppSizes.h2),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        
        if (hasEdit)
          TextButton(
            onPressed: onEdit,
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: AppSizes.sp12,
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}