import 'package:flutter/material.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class PersonSelectorBottomSheet extends StatefulWidget {
  final int initialCount;
  final Function(int) onCountSelected;

  const PersonSelectorBottomSheet({
    super.key,
    required this.initialCount,
    required this.onCountSelected,
  });

  @override
  State<PersonSelectorBottomSheet> createState() => _PersonSelectorBottomSheetState();
}

class _PersonSelectorBottomSheetState extends State<PersonSelectorBottomSheet> {
  late int selectedCount;

  @override
  void initState() {
    super.initState();
    selectedCount = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.r20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(height: AppSizes.h20),
          
          Text(
            'Number of Persons',
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          
          SizedBox(height: AppSizes.h30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onPressed: selectedCount > 1 
                    ? () => setState(() => selectedCount--)
                    : null,
              ),
              
              SizedBox(width: AppSizes.w24),
              
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$selectedCount',
                    style: TextStyle(
                      fontSize: AppSizes.sp24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: AppSizes.w24),
              
              _buildCounterButton(
                icon: Icons.add,
                onPressed: selectedCount < 10 
                    ? () => setState(() => selectedCount++)
                    : null,
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.h30),
          
          Text(
            'person${selectedCount > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: AppSizes.sp16,
              color: Colors.grey.shade600,
            ),
          ),
          
          SizedBox(height: AppSizes.h30),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: AppSizes.w12),
              
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCountSelected(selectedCount);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed != null ? Colors.white : Colors.grey.shade500,
          size: 20,
        ),
      ),
    );
  }
}