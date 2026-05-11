import 'package:flutter/material.dart';
import 'package:habispace/core/theme/app_theme.dart';
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

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null
        ? '${selectedDate!.day} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year} - 09:00'
        : '12 September 2025 - 09:00';

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
            'Booking Detail',
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
              color: context.appTheme.titleText,
            ),
          ),
          SizedBox(height: AppSizes.h16),
          _DetailRow(
            title: 'Book Appointment',
            value: dateText,
            hasEdit: true,
            onEdit: onEditDate,
          ),
          SizedBox(height: AppSizes.h12),
          _DetailRow(
            title: 'Person',
            value: '$personCount person${personCount > 1 ? 's' : ''}',
            hasEdit: true,
            onEdit: onEditPerson,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool hasEdit;
  final VoidCallback? onEdit;

  const _DetailRow({
    required this.title,
    required this.value,
    this.hasEdit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: context.appTheme.titleText,
                ),
              ),
              SizedBox(height: AppSizes.h2),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: context.appTheme.subtleText,
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
}
