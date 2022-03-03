part of 'create_user_cubit.dart';

@immutable
abstract class CreateCustomerState extends Equatable {}

class CreateCustomerCreating extends CreateCustomerState {
  @override
  List<Object?> get props => [];
}

class CreateCustomerInitial extends CreateCustomerState {
  @override
  List<Object?> get props => [];
}

class CreateCustomerError extends CreateCustomerState {
  final String error;

  CreateCustomerError(this.error);

  @override
  List<Object?> get props => [error];
}

