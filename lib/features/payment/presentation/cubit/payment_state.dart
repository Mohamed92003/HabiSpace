part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentLoaded extends PaymentState {
  final PaymentEntity payment;
  
  PaymentLoaded(this.payment);
}

final class PaymentError extends PaymentState {
  final String message;
  
  PaymentError(this.message);
}