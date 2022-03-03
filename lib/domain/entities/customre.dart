import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final int dateOfBirth;
  final String phoneNumber;
  final String email;
  final String bankAccountNumber;

  const Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.bankAccountNumber,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      dateOfBirth: map['dateOfBirth'] as int,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      bankAccountNumber: map['bankAccountNumber'] as String,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, dateOfBirth, phoneNumber, email, bankAccountNumber];
}
