import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mc_crud_test/application/extension/string.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/presentation/bloc/update/edit_customer_cubit.dart';
import 'package:phone_number/phone_number.dart';
import 'package:styled_widget/styled_widget.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({Key? key, required this.initialData}) : super(key: key);
  final Customer initialData;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final maskFormatter = MaskTextInputFormatter(mask: '+## (#) ########', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController dateController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController backAccountNumberController;

  String? _validatePhone;
  int? birthDate;

  @override
  void initState() {
    firstNameController = TextEditingController()..text = widget.initialData.firstName;
    lastNameController = TextEditingController()..text = widget.initialData.lastName;
    dateController = TextEditingController()..text = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.initialData.dateOfBirth));
    birthDate = widget.initialData.dateOfBirth;
    phoneController = TextEditingController()..text = maskFormatter.maskText(widget.initialData.phoneNumber);
    emailController = TextEditingController()..text = widget.initialData.email;
    backAccountNumberController = TextEditingController()..text = widget.initialData.bankAccountNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCustomerCubit, EditCustomerState>(listener: (context, state) {
      if (state is EditCustomerError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.error}'),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is EditCustomerInitial || state is EditCustomerEditing || state is EditCustomerError) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              try {
                await PhoneNumberUtil().parse(phoneController.text);
                _validatePhone = null;
              } catch (e) {
                _validatePhone = "Not Valid Phone";
              }
              if (_key.currentState!.validate()) {
                var res = await context.read<EditCustomerCubit>().editCustomer(
                      customer: Customer(
                        id: widget.initialData.id,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        dateOfBirth: birthDate!,
                        phoneNumber: phoneController.text.replaceAll(')', '').replaceAll('(', '').replaceAll(' ', ''),
                        email: emailController.text,
                        bankAccountNumber: backAccountNumberController.text,
                      ),
                    );
                if (res == true) {
                  Get.back(result: res);
                }
              }
            },
            label: state is EditCustomerEditing ? const CupertinoActivityIndicator() : const Text('Edit Customer'),
          ),
          body: SafeArea(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? v) => v.isValidString() ? null : 'Not Valid First Name',
                  ).padding(top: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? v) => v.isValidString(maxLength: 25) ? null : 'Not Valid Last Name',
                  ).padding(top: 10),
                  TextFormField(
                    readOnly: true,
                    controller: dateController,
                    onTap: () async {
                      initializeDateFormatting('en_US', null);
                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: DateTime.now(),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        birthDate = date.millisecondsSinceEpoch;
                        dateController.text = DateFormat.yMMMd().format(date);
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Date of Birthday'),
                    validator: (v) => birthDate == null ? 'Not Valid birthday' : null,
                  ).padding(top: 10),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Phone (+31615823033)'),
                    inputFormatters: [
                      maskFormatter,
                    ],
                    validator: (String? v) => _validatePhone,
                  ).padding(top: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? v) => v.isValidEmail ? null : 'Not Valid Email',
                  ).padding(top: 10),
                  TextFormField(
                    controller: backAccountNumberController,
                    decoration: const InputDecoration(hintText: 'Bank Account Number'),
                    maxLength: 16,
                    validator: (String? v) => v.isValidString(maxLength: 16, minLength: 16) ? null : 'Not valid Account Number',
                  ).padding(top: 10),
                ],
              ).padding(horizontal: 15),
            ),
          ),
        );
      }

      return const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    });
  }
}
