import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mc_crud_test/application/error/mapError.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';
import 'package:meta/meta.dart';

part 'create_user_state.dart';

class CreateCustomerCubit extends Cubit<CreateCustomerState> {
  CreateCustomerCubit(this.customerUseCase) : super(CreateCustomerInitial());
  final CustomerUseCase customerUseCase;

  Future createCustomer({
    required Customer customer,
  }) async {
    emit(CreateCustomerCreating());
    var result = await customerUseCase.createCustomer(customer);
    emit(result.fold((l) => CreateCustomerError(mapError(l)), (r) => CreateCustomerInitial()));
    return result.isRight();
  }
}
