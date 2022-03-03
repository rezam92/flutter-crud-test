import 'package:mc_crud_test/data/repos/customer_repo.dart';
import 'package:mc_crud_test/data/services/db_services.dart';
import 'package:mc_crud_test/domain/repos/customre_repo.dart';

class RepoModule {
  static CustomerRepo? _customerRepo;
  static DBService dbService = DBService();
  static CustomerRepo get getCustomerRepo{
    _customerRepo ??= CustomerRepoImpl(dbService);
    return _customerRepo!;
  }
}