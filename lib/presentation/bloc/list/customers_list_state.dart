part of 'customers_list_cubit.dart';

@immutable
abstract class CustomersListState extends Equatable {
  const CustomersListState();
}

class CustomersListInitial extends CustomersListState {
  @override
  List<Object> get props => [];
}

class CustomersListLoaded extends CustomersListState {
  final List<Customer> list;

  const CustomersListLoaded(this.list);

  @override
  List<Object> get props => [list];

  CustomersListLoaded copyWith({
    List<Customer>? list,
  }) {
    return CustomersListLoaded(
      list ?? this.list,
    );
  }
}

class CustomersListError extends CustomersListState {
  final String error;

  const CustomersListError(this.error);

  @override
  List<Object> get props => [error];
}
