 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_sizes.dart';
import 'package:habispace/features/details/domain/entities/property_detail_entity.dart';
import 'package:habispace/features/payment/data/datasource/payment_remote_datasource_impl.dart';
import 'package:habispace/features/payment/data/repoimpl/payment_repo_impl.dart';
import 'package:habispace/features/payment/domain/usecases/create_payment_usecase.dart';
import 'package:habispace/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:habispace/features/payment/presentation/ui/payment_webview.dart';
import 'package:habispace/features/payment/presentation/widgets/booking_details_section.dart';
import 'package:habispace/features/payment/presentation/widgets/date_picker_bottom_sheet.dart';
import 'package:habispace/features/payment/presentation/widgets/person_selector_bottom_sheet.dart';
import 'package:habispace/features/payment/presentation/widgets/price_details_section.dart';
import 'package:habispace/features/payment/presentation/widgets/property_summary_card.dart';

class PaymentView extends StatelessWidget {
  final PropertyDetailEntity property;

  const PaymentView({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(
        CreatePaymentUseCase(
          PaymentRepoImpl(PaymentRemoteDataSourceImpl()),
        ),
      ),
      child: PaymentBody(property: property),
    );
  }
}

class PaymentBody extends StatefulWidget {
  final PropertyDetailEntity property;

  const PaymentBody({super.key, required this.property});

  @override
  State<PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> with WidgetsBindingObserver {
  DateTime? selectedDate;
  int personCount = 4;
  bool _paymentInitiated = false; // true بعد ما يضغط Finish ويرجع من الـ browser

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // لما اليوزر يرجع من الـ browser للـ app
    if (state == AppLifecycleState.resumed && _paymentInitiated) {
      setState(() {
        _paymentInitiated = true; // الزر يفضل disabled
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Request to Book',
          style: TextStyle(
            fontSize: AppSizes.sp18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoaded) {
            final url = state.payment.paymentUrl;
            debugPrint('Payment URL: $url');
            if (url.isNotEmpty) {
              setState(() => _paymentInitiated = true);
              _launchPaymentUrl(url);
            } else {
              // الـ order اتعمل بنجاح لكن مفيش payment URL (stripe session لسه مش جاهز)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Your booking request was submitted successfully. You will be notified once payment is ready.',
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 5),
                ),
              );
              setState(() => _paymentInitiated = true);
            }
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.w16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PropertySummaryCard(property: widget.property),
                      
                      SizedBox(height: AppSizes.h20),
                      
                      BookingDetailsSection(
                        selectedDate: selectedDate,
                        personCount: personCount,
                        onEditDate: _showDatePicker,
                        onEditPerson: _showPersonSelector,
                      ),
                      
                      SizedBox(height: AppSizes.h20),
                      
                      PriceDetailsSection(property: widget.property),
                      
                      SizedBox(height: AppSizes.h20),
                      
                      _buildCancellationPolicy(),
                    ],
                  ),
                ),
              ),
              
              _buildBottomButton(context, state),
            ],
          );
        },
      ),
    );
  }

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDate: selectedDate,
        onDateSelected: (date) {
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  void _showPersonSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PersonSelectorBottomSheet(
        initialCount: personCount,
        onCountSelected: (count) {
          setState(() {
            personCount = count;
          });
        },
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return _CancellationPolicySection();
  }

  Widget _buildBottomButton(BuildContext context, PaymentState state) {
    final isLoading = state is PaymentLoading;
    final isDisabled = isLoading || _paymentInitiated;

    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_paymentInitiated)
              Padding(
                padding: EdgeInsets.only(bottom: AppSizes.h8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: AppSizes.h16),
                    SizedBox(width: AppSizes.w6),
                    Text(
                      'Payment submitted — awaiting confirmation',
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDisabled ? null : () => context.read<PaymentCubit>().createPayment(widget.property.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDisabled ? Colors.grey.shade300 : AppColors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _paymentInitiated ? 'Payment Submitted' : 'Finish',
                        style: TextStyle(
                          fontSize: AppSizes.sp16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPaymentUrl(String url) async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebView(url: url, title: 'Complete Payment'),
      ),
    );
    // لما اليوزر يرجع من الـ WebView
    if (mounted) {
      setState(() => _paymentInitiated = true);
    }
  }
}

// ── Cancellation Policy Section ───────────────────────────────────────────────

class _CancellationPolicySection extends StatefulWidget {
  const _CancellationPolicySection();

  @override
  State<_CancellationPolicySection> createState() =>
      _CancellationPolicySectionState();
}

class _CancellationPolicySectionState
    extends State<_CancellationPolicySection> {
  bool _expanded = false;

  static const String _shortText =
      'Free cancellation within 48 hours. If canceled before June 1, you will receive a partial refund.';

  static const String _fullText =
      'Free cancellation within 48 hours. If canceled before June 1, you will receive a partial refund.\n\n'
      'After June 1, cancellations are non-refundable. In case of emergency or force majeure, '
      'please contact our support team within 24 hours of the scheduled appointment.\n\n'
      'HabiSpace reserves the right to cancel bookings in case of property unavailability, '
      'in which case a full refund will be issued within 5-7 business days.';

  @override
  Widget build(BuildContext context) {
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
            'Cancellation Policy',
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppSizes.h12),
          Text(
            _expanded ? _fullText : _shortText,
            style: TextStyle(
              fontSize: AppSizes.sp14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSizes.h8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Read less' : 'Read more',
              style: TextStyle(
                fontSize: AppSizes.sp14,
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
