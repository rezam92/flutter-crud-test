import 'package:mc_crud_test/application/error/exception.dart';
import 'package:mc_crud_test/application/error/failure.dart';
import 'package:mc_crud_test/data/services/db_services.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/repos/customre_repo.dart';
import 'package:dartz/dartz.dart';

class CustomerRepoImpl extends CustomerRepo {
  final DBService _dbService;

  CustomerRepoImpl(this._dbService);

  @override
  Future<Either<Failure, List<Customer>>> getCustomers() async {
    try{
      var res = await _dbService.getCustomers();
      return Right(res);
    } catch (e){
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createCustomers(Customer customer) async {
    try {
      await _dbService.createCustomer(customer);
      return const Right(null);
    }
    on ExistenceCustomerException  {
      print('EX');
      return Left(ExistenceCustomerFailure());
    } on DBException {
      print('DB');
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, Customer>> readCustomer(int id) async {
    try {
      Customer res = await _dbService.readCustomer(id);
      return Right(res);
    } on DBException {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomers(Customer customer) async {
    try {
      await _dbService.updateCustomer(customer);
      return const Right(null);
    } on DBException {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomers(int id) async {
    try {
      await _dbService.deleteCustomer(id);
      return const Right(null);
    } on DBException {
      return Left(DBFailure());
    }
  }
}
