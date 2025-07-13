part of '../cubits/send_money_cubit.dart';

class SendMoneyError extends SendMoneyState {
  final String message;

  const SendMoneyError({required this.message});

  @override
  List<Object> get props => [message];
}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();

  @override
  List<Object?> get props => [];
}

class SendMoneySuccess extends SendMoneyState {
  final Transaction transaction;

  const SendMoneySuccess({required this.transaction});

  @override
  List<Object> get props => [transaction];
}
