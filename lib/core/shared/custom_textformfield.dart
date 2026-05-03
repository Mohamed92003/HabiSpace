import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_color.dart';

class CustomTextformfeild extends StatefulWidget {
  const CustomTextformfeild({
    required this.keyboardType,
    required this.controller,
     this.validator,
     this.formFieldKey,
    this.borderRadius,
    this.hintText,
    this.labelText,
    this.labelcolor,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.isPhoneField = false,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final Key? formFieldKey;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool isPhoneField;
  final Color? labelcolor;
  final double? borderRadius;
  final String? errorText;
  final void Function(String)? onChanged;

  @override
  State<CustomTextformfeild> createState() => _CustomTextformfeildState();
}

class _CustomTextformfeildState extends State<CustomTextformfeild> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8.h),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: widget.labelcolor ?? AppColors.secondaryColor,
              ),
            ),
          ),

        if (widget.isPhoneField && widget.prefixText != null)
          Row(
            children: [
              Container(
                width: 55.w,
                height: 55.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  shape: BoxShape.circle,
                  color: AppColors.light,
                ),
                child: Center(
                  child: Text(
                    widget.prefixText!,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryColor),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(child: _buildTextField(isRTL)),
            ],
          )
        else
          _buildTextField(isRTL),
      ],
    );
  }

  Widget _buildTextField(bool isRTL) {
    return TextFormField(
      key: widget.formFieldKey,
      validator: widget.validator,
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? _obscureText : false,
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isRTL ? TextAlign.right : TextAlign.left,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      // ستايل النص المكتوب داخل الحقل
      style: TextStyle(
        fontSize: 16.sp,
        color: AppColors.black,
      ),
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: widget.hintText,
        // ستايل نص التلميح
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textLightColor,
        ),
        filled: true,
        fillColor: AppColors.lightGrayColor,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        // ستايل نص الخطأ
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.error,
          height: 1,
        ),
        border: _buildOutlineBorder(),
        enabledBorder: _buildOutlineBorder(),
        focusedBorder: _buildOutlineBorder(color: AppColors.blue, width: 1.5),
        errorBorder: _buildOutlineBorder(color: AppColors.error, width: 1.5),
        focusedErrorBorder: _buildOutlineBorder(color: AppColors.error, width: 1.5),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                 backgroundColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 splashFactory: NoSplash.splashFactory,
                    ),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondaryColor,
                  size: 22.sp,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffixIcon,
      ),
    );
  }

  // دالة داخلية لبناء الحدود لتجنب التكرار
  OutlineInputBorder _buildOutlineBorder({Color color = AppColors.borderColor, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}