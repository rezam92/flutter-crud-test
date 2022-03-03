import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mc_crud_test/presentation/bloc/update/edit_customer_cubit.dart';
import 'package:mc_crud_test/presentation/bloc/view/customer_view_cubit.dart';
import 'package:styled_widget/styled_widget.dart';

import '../update/edit_customer.dart';

class CustomerView extends StatelessWidget {
  CustomerView({Key? key}) : super(key: key);
  final maskFormatter = MaskTextInputFormatter(mask: '+## (#) ########', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerViewCubit, CustomerViewState>(listener: (context, state) {
      if (state is CustomerViewError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is CustomerViewLoaded) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              var result = await Get.to(
                BlocProvider(
                  create: (_) => EditCustomerCubit(context.read<CustomerViewCubit>().customerUseCase),
                  child: EditCustomer(initialData: state.customer),
                ),
              );
              if (result == true) {
                await context.read<CustomerViewCubit>().getCustomerDetail();
              }
            },
            label: const Text('Edit'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Text(state.customer.firstName),
                TextFormField(
                  controller: TextEditingController()..text = state.customer.firstName,
                  decoration: const InputDecoration(
                    label: Text('First Name'),
                  ),
                  readOnly: true,
                ).padding(top: 10),
                TextFormField(
                  controller: TextEditingController()..text = state.customer.lastName,
                  decoration: const InputDecoration(
                    label: Text('Last Name'),
                  ),
                  readOnly: true,
                ).padding(top: 10),
                TextFormField(
                  controller: TextEditingController()..text = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(state.customer.dateOfBirth)),
                  decoration: const InputDecoration(
                    label: Text('Day of Birthday'),
                  ),
                  readOnly: true,
                ).padding(top: 10),
                TextFormField(
                  controller: TextEditingController()..text = maskFormatter.maskText(state.customer.phoneNumber),
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Phone Number'),
                  ),
                ).padding(top: 10),
                TextFormField(
                  controller: TextEditingController()..text = state.customer.email,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  readOnly: true,
                ).padding(top: 10),
                TextFormField(
                  controller: TextEditingController()..text = state.customer.bankAccountNumber,
                  decoration: const InputDecoration(
                    label: Text('Bank Account Number'),
                  ),
                  readOnly: true,
                ).padding(top: 10),
              ],
            ).padding(horizontal: 15),
          ),
        );
      }

      if (state is CustomerViewError) {
        return Scaffold(
          body: Center(
            child: Text('Error: ${state.error}'),
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
