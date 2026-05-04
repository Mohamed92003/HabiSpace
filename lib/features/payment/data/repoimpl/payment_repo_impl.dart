import 'package:habispace/features/payment/data/datasource/payment_remote_datasource.dart';
import 'package:habispace/features/payment/domain/Entities/payment_entity.dart';
import 'package:habispace/features/payment/domain/repo/payment_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepoImpl(this.remoteDataSource);

  @override
  Future<PaymentEntity> createPayment(int propertyId) async {
    return await remoteDataSource.createPayment(propertyId);
  }
}
