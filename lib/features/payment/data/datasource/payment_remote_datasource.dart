import 'package:habispace/features/payment/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment(int propertyId);
}
