import 'package:dartz/dartz.dart';
import 'package:mc_crud_test/application/error/failure.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/repos/customre_repo.dart';

class CustomerUseCase {
  final CustomerRepo customerRepo;

  const CustomerUseCase({
    required this.customerRepo,
  });

  Future<Either<Failure, List<Customer>>> getCustomerList() async {
    return await customerRepo.getCustomers();
  }

  Future<Either<Failure, void>> createCustomer(Customer customer) async {
    return await customerRepo.createCustomers(customer);
  }

  Future<Either<Failure, Customer>> readCustomer(int id) async {
    return await customerRepo.readCustomer(id);
  }

  Future<Either<Failure, void>> updateCustomer(Customer customer) async {
    return await customerRepo.updateCustomers(customer);
  }

  Future<Either<Failure, void>> deleteCustomer(int id) async {
    return await customerRepo.deleteCustomers(id);
  }
}