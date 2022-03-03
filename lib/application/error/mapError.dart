import 'failure.dart';

String mapError(Failure failure) {
  switch (failure.runtimeType){
    case UnknownFailure:
      return "Sorry, Unknown Failure";
    case DBFailure:
      return "Sorry, Database has error";
    case ExistenceCustomerFailure:
      return "Sorry, This email has been registered";
    default:
      return '';
  }
}