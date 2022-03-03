import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/repos/customre_repo.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'customers_usecase_test.mocks.dart';

// class MockCustomerRepository extends Mock implements CustomerRepo {}

@GenerateMocks([CustomerRepo])
void main() {
  late CustomerUseCase usecase;
  late MockCustomerRepo mockRepository;

  setUp(() {
    mockRepository = MockCustomerRepo();
    usecase = CustomerUseCase(customerRepo: mockRepository);
  });

  test(
    'should read list of customers',
    () async {
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
      // arrange
      when(mockRepository.getCustomers()).thenAnswer((_) async => const Right(customers));
      //
      // act
      final result = await usecase.getCustomerList();

      // assert
      expect(result, const Right(customers));
      if(result.isRight()){
        var list = result.toOption().toNullable();
        if(list!= null) {
          expect(list.length, 2);
          expect(list.first, customers.first);
        }
      }
      verify(mockRepository.getCustomers());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should be one customer after create',
        () async {
      const customer = Customer(
        id: 1,
        firstName: 'Reza',
        lastName: 'Mahmoudi',
        dateOfBirth: 164985395,
        phoneNumber: '+31634568709',
        email: 'reza@yahoo.com',
        bankAccountNumber: '1467436587435632',
      );

      List<Customer> mainList = [];

      // arrange
      when(mockRepository.createCustomers(any)).thenAnswer((_) async{
        mainList.add(customer);
        return const Right(null);
      });

      // act
      final result = await usecase.createCustomer(customer);

      // assert
      expect(result, const Right(null));
      if(result.isRight()){
        expect(mainList.length, 1);
      }
      verify(mockRepository.createCustomers(customer));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should read one customer',
        () async {

      int id = 2;

      const mainList = [
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


      // arrange
      when(mockRepository.readCustomer(any)).thenAnswer((_) async{
        return Right(mainList.where((e) => e.id == id).first);
      });

      // act
      final result = await usecase.readCustomer(id);

      // assert
      expect(result, Right(mainList[1]));
      if(result.isRight()){
        expect(result.toOption().toNullable()!.email, 'ali@yahoo.com');
      }
      verify(mockRepository.readCustomer(id));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should update customer',
        () async {

      int id = 2;
      String newName = "MohammadReza";

      var mainList = [
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


      // arrange
      when(mockRepository.updateCustomers(any)).thenAnswer((_) async{
        var index = mainList.indexWhere((e) => e.id == id);
        mainList[index] = (mainList[index]).copyWith(firstName: newName);
        return const Right(null);
      });

      // act
      final result = await usecase.updateCustomer(mainList[1].copyWith(firstName: newName));

      // assert
      expect(result, const Right(null));
      if(result.isRight()){
        expect(mainList[1].firstName, newName);
      }
      verify(mockRepository.updateCustomers(mainList[1].copyWith(firstName: newName)));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should delete customer',
        () async {

      int id = 2;

      var mainList = [
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


      // arrange
      when(mockRepository.deleteCustomers(any)).thenAnswer((_) async{
        mainList.removeWhere((e) => e.id == id);
        return const Right(null);
      });

      // act
      final result = await usecase.deleteCustomer(id);

      // assert
      expect(result, const Right(null));
      if(result.isRight()){
        expect(mainList.where((e) => e.id == id).isEmpty, true);
      }
      verify(mockRepository.deleteCustomers(id));
      verifyNoMoreInteractions(mockRepository);
    },
  );

}
