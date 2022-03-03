import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mc_crud_test/application/error/mapError.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';

part 'edit_customer_state.dart';

class EditCustomerCubit extends Cubit<EditCustomerState> {
  EditCustomerCubit(this.customerUseCase) : super(EditCustomerInitial());
  final CustomerUseCase customerUseCase;

  Future editCustomer({required Customer customer}) async {
    emit(EditCustomerEditing());
    var result = await customerUseCase.updateCustomer(customer);
    emit(result.fold((l) => EditCustomerError(mapError(l)), (r) => EditCustomerInitial()));
    return result.isRight();
  }
}
