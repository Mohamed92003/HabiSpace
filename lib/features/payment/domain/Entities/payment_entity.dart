import 'package:habispace/features/details/domain/entities/property_detail_entity.dart';

class PaymentEntity {
  final String amount;
  final String currency;
  final String status;
  final String? stripeSessionId;
  final DateTime createdAt;
  final PropertyDetailEntity propertyDetailEntity;
  final String paymentUrl;
  
  PaymentEntity({
    required this.amount,
    required this.currency,
    required this.status,
    required this.stripeSessionId,
    required this.createdAt,
    required this.propertyDetailEntity,
    required this.paymentUrl,
  });
}
