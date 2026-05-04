import 'package:flutter/material.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final String paymentUrl;
  final VoidCallback onContinue;

  const PaymentSuccessDialog({
    super.key,
    required this.paymentUrl,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),
            
            SizedBox(height: AppSizes.h20),
            
            Text(
              'Payment Created Successfully!',
              style: TextStyle(
                fontSize: AppSizes.sp18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppSizes.h12),
            
            Text(
              'Your booking request has been created. You will be redirected to complete the payment.',
              style: TextStyle(
                fontSize: AppSizes.sp14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppSizes.h24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                ),
                child: Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}