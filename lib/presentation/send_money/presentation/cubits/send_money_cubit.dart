import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/shared/constants/shared_prefs_keys.dart';

import '../../../wallet/domain/entities/transaction.dart';
import '../../domain/repositories/send_money_repository.dart';

part '../models/send_money_state.dart';

@injectable
class SendMoneyCubit extends Cubit<SendMoneyState> {
  final SendMoneyRepository _sendMoneyRepository;
  final SharedPreferenceStorage _storage;

  SendMoneyCubit(this._sendMoneyRepository, this._storage)
    : super(SendMoneyInitial());

  Future<void> checkMockFailure() async {
    final mockError = await _storage.getValue<String>(
      SharedPrefsKeys.mockErrorSendMoney,
    );
    emit(SendMoneyMockFailureToggled(mockError == 'true'));
  }

  Future<void> disableMockFailure() async {
    await _storage.setValue(SharedPrefsKeys.mockErrorSendMoney, 'false');
    emit(SendMoneyMockFailureToggled(false));
  }

  void resetState() {
    emit(SendMoneyInitial());
  }

  Future<void> sendMoney(double amount) async {
    emit(SendMoneyLoading());

    try {
      final mockError = await _storage.getValue<String>(
        SharedPrefsKeys.mockErrorSendMoney,
      );
      if (mockError == 'true') {
        throw Exception('Mock failure for testing');
      }

      final transaction = await _sendMoneyRepository.sendMoney(amount);
      emit(SendMoneySuccess(transaction: transaction));
    } catch (e) {
      emit(SendMoneyError(message: e.toString()));
    }
  }

  Future<void> simulateFailure() async {
    await _storage.setValue(SharedPrefsKeys.mockErrorSendMoney, 'true');
    emit(SendMoneyMockFailureToggled(true));
  }
}

class SendMoneyMockFailureToggled extends SendMoneyState {
  final bool enabled;
  const SendMoneyMockFailureToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
