import 'package:mc_crud_test/application/error/exception.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  Future<List<Customer>> getCustomers() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customerApp.db');
    try {
      Database db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE `Customer` (
            `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            `firstName` VARCHAR(25) NOT NULL,
            `lastName` VARCHAR(40) NOT NULL,
            `dateOfBirth` INT NOT NULL,
            `email` VARCHAR(50),
            `phoneNumber` VARCHAR(13),
            `bankAccountNumber` VARCHAR(16)      
          )''');
        },
      );
      List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM Customer');

      await db.close();
      // return [];
      return list.map((e) => Customer.fromMap(e)).toList();
    } catch (e) {
      throw DBException();
    }
  }

  Future<void> createCustomer(Customer customer) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customerApp.db');

    try {
      Database db = await openDatabase(
        path,
        version: 1,
      );
      List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM  Customer WHERE email = ?', [customer.email]);

      if (list.isNotEmpty) {
        throw ExistenceCustomerException();
      }
      db.rawInsert(
        '''
              INSERT INTO Customer(firstName,lastName,dateOfBirth,email,phoneNumber,bankAccountNumber) 
                VALUES("${customer.firstName}", "${customer.lastName}", ${customer.dateOfBirth},
                "${customer.email}","${customer.phoneNumber}","${customer.bankAccountNumber}")
          ''',
      );
      await db.close();
    } on ExistenceCustomerException {
      throw ExistenceCustomerException();
    } catch (e) {
      throw DBException();
    }
  }

  Future<Customer> readCustomer(int id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customerApp.db');
    try {
      Database db = await openDatabase(
        path,
        version: 1,
      );
      List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM  Customer WHERE id = ?', [id]);
      await db.close();
      return Customer.fromMap(list.first);
    } catch (e) {
      throw DBException();
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customerApp.db');
    try {
      Database db = await openDatabase(
        path,
        version: 1,
      );
      await db.rawUpdate(
        '''
          UPDATE Customer SET firstName = ?, lastName = ?, dateOfBirth = ?,
          email = ?, phoneNumber = ?, bankAccountNumber = ? 
          WHERE id = ?
        ''',
        [
          customer.firstName,
          customer.lastName,
          customer.dateOfBirth,
          customer.email,
          customer.phoneNumber,
          customer.bankAccountNumber,
          customer.id,
        ],
      );

      await db.close();
    } catch (e) {
      print(e);
      throw DBException();
    }
  }

  Future<void> deleteCustomer(int id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customerApp.db');
    try {
      Database db = await openDatabase(
        path,
        version: 1,
      );
      await db.rawDelete('DELETE FROM Customer WHERE id = ?', [id]);
      await db.close();
    } catch (e) {
      throw DBException();
    }
  }
}
