import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mc_crud_test/application/error/mapError.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';

part 'customer_view_state.dart';

class CustomerViewCubit extends Cubit<CustomerViewState> {
  CustomerViewCubit({required this.id, required this.customerUseCase}) : super(CustomerViewInitial()){
    getCustomerDetail();
  }
  final CustomerUseCase customerUseCase;
  final int id;

  Future getCustomerDetail() async{
    var result = await customerUseCase.readCustomer(id);
    emit(result.fold((l) => CustomerViewError(mapError(l)), (r) => CustomerViewLoaded(r)));
  }

}
