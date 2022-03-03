import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class UnknownFailure extends Failure {}

class DBFailure extends Failure {}

class ExistenceCustomerFailure extends Failure {}
