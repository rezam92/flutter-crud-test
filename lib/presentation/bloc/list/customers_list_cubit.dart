import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_crud_test/application/error/failure.dart';
import 'package:mc_crud_test/application/error/mapError.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';

part 'customers_list_state.dart';

class CustomersListCubit extends Cubit<CustomersListState> {
  CustomersListCubit(this.customerUseCase) : super(CustomersListInitial()) {
    getCustomersList();
  }

  final CustomerUseCase customerUseCase;

  Future getCustomersList() async {
    var list = await customerUseCase.getCustomerList();

    emit(list.fold((l) => CustomersListError(mapError(l)), (r) => CustomersListLoaded(r)));
  }

  Future deleteCustomer(int id) async {
    var _state = state as CustomersListLoaded;
    emit(CustomersListInitial());
    var result = await customerUseCase.deleteCustomer(id);
    if (result.isRight()) {
      getCustomersList();
    } else {
      emit(CustomersListError(mapError(result.fold((l) => l, (r) => UnknownFailure()))));
      emit(_state.copyWith());
    }
  }

  Future updateCustomer(int id) async {
    var _state = state as CustomersListLoaded;
    var result = await customerUseCase.readCustomer(id);
    var res = result.fold((l) => l, (r) => r);
    if (res is Customer) {
      List<Customer> list = List.from(_state.list);
      var index = list.indexWhere((e) => e.id == res.id);
      list[index] = res;
      emit(CustomersListLoaded(list));
    }
  }
}
