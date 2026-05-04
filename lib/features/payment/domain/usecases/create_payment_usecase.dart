import 'package:habispace/features/payment/domain/Entities/payment_entity.dart';
import 'package:habispace/features/payment/domain/repo/payment_repo.dart';

class CreatePaymentUseCase {
  final PaymentRepo repository;

  CreatePaymentUseCase(this.repository);

  Future<PaymentEntity> call(int propertyId) async {
    return await repository.createPayment(propertyId);
  }
}