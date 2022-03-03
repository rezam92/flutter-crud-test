import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_crud_test/application/error/failure.dart';
import 'package:mc_crud_test/application/error/mapError.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/repos/customre_repo.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';
import 'package:mc_crud_test/presentation/bloc/list/customers_list_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../domain/usecases/customers_usecase_test.mocks.dart';

void main() {
  const customers = [
    Customer(
      id: 1,
      firstName: 'Reza',
      lastName: 'Mahmoudi',
      dateOfBirth: 164985395,
      phoneNumber: '+31634568709',
      email: 'reza@yahoo.com',
      bankAccountNumber: '1467436587435632',
    ),
    Customer(
      id: 2,
      firstName: 'Ali',
      lastName: 'Mahmoudi',
      dateOfBirth: 164985395,
      phoneNumber: '+31634568709',
      email: 'ali@yahoo.com',
      bankAccountNumber: '1467436587435632',
    ),
  ];

  late MockCustomerRepo mockRepository;// = MockCustomerRepo();
  late CustomerUseCase usecase;
  late CustomersListCubit cubit;

  setUp(() {
    mockRepository = MockCustomerRepo();
    usecase = CustomerUseCase(customerRepo: mockRepository);
    cubit = CustomersListCubit(usecase);
  });

  test(('init state'), (){
    expect(cubit.state, equals(CustomersListInitial()));
  });

  test(('loaded state'), ()async{
    when(mockRepository.getCustomers()).thenAnswer((_) async => const Right(customers));
    await cubit.getCustomersList();
    expect(cubit.state, equals(const CustomersListLoaded(customers)));
  });

  test(('error state'), ()async{
    when(mockRepository.getCustomers()).thenAnswer((_) async => Left(DBFailure()));
    await cubit.getCustomersList();
    expect(cubit.state, equals(CustomersListError(mapError(DBFailure()))));
  });

}
