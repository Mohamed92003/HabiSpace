import 'package:habispace/features/details/data/models/property_detail_model.dart';
import 'package:habispace/features/payment/domain/Entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required super.amount,
    required super.currency,
    required super.status,
    required super.stripeSessionId,
    required super.createdAt,
    required super.propertyDetailEntity,
    required super.paymentUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'] as Map<String, dynamic>?;
    if (responseData == null) {
      throw Exception('Invalid response: missing data field.');
    }
    final orderData = responseData['order'] as Map<String, dynamic>?;
    if (orderData == null) {
      throw Exception('Invalid response: missing order data.');
    }

    return PaymentModel(
      amount: orderData['amount']?.toString() ?? '0',
      currency: orderData['currency']?.toString() ?? 'usd',
      status: orderData['status']?.toString() ?? 'pending',
      stripeSessionId: orderData['stripe_checkout_session_id']?.toString(),
      createdAt: DateTime.parse(orderData['created_at'].toString()),
      propertyDetailEntity: PropertyDetailModel.fromJson(
        orderData['property'] as Map<String, dynamic>,
      ),
      paymentUrl: responseData['payment_url']?.toString() ?? '',
    );
  }
}
