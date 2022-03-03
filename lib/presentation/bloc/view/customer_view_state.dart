part of 'customer_view_cubit.dart';

abstract class CustomerViewState extends Equatable {
  const CustomerViewState();
}

class CustomerViewInitial extends CustomerViewState {
  @override
  List<Object> get props => [];
}

class CustomerViewLoaded extends CustomerViewState {
  final Customer customer;

  const CustomerViewLoaded(this.customer);

  @override
  List<Object> get props => [customer];
}

class CustomerViewError extends CustomerViewState {
  final String error;

  const CustomerViewError(this.error);

  @override
  List<Object> get props => [error];
}
