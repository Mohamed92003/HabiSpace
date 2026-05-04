import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:habispace/features/payment/domain/Entities/payment_entity.dart';
import 'package:habispace/features/payment/domain/usecases/create_payment_usecase.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreatePaymentUseCase createPaymentUseCase;

  PaymentCubit(this.createPaymentUseCase) : super(PaymentInitial());

  Future<void> createPayment(int propertyId) async {
    emit(PaymentLoading());
    try {
      final payment = await createPaymentUseCase.call(propertyId);
      emit(PaymentLoaded(payment));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}