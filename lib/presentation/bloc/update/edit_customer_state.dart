part of 'edit_customer_cubit.dart';

abstract class EditCustomerState extends Equatable {
  const EditCustomerState();
}

class EditCustomerInitial extends EditCustomerState {
  @override
  List<Object> get props => [];
}

class EditCustomerEditing extends EditCustomerState {
  @override
  List<Object> get props => [];
}

class EditCustomerError extends EditCustomerState {
  final String error;
  const EditCustomerError(this.error);
  @override
  List<Object> get props => [error];
}
