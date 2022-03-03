import 'package:dartz/dartz.dart';
import 'package:mc_crud_test/application/error/failure.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';

abstract class CustomerRepo {
  Future<Either<Failure, List<Customer>>> getCustomers();
  Future<Either<Failure, void>> createCustomers(Customer customer);
  Future<Either<Failure, Customer>> readCustomer(int id);
  Future<Either<Failure, void>> updateCustomers(Customer customer);
  Future<Either<Failure, void>> deleteCustomers(int id);
}