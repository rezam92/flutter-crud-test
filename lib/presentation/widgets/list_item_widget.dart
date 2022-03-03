import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mc_crud_test/presentation/bloc/list/customers_list_cubit.dart';
import 'package:mc_crud_test/presentation/bloc/view/customer_view_cubit.dart';
import 'package:mc_crud_test/presentation/pages/view/cutomer_view.dart';
import 'package:styled_widget/styled_widget.dart';

class ListItemWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final int id;

  const ListItemWidget({Key? key, required this.firstName, required this.lastName, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersListCubit, CustomersListState>(
      builder:(context, state) =>  Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(child: Text('$firstName $lastName')),
            IconButton(
              icon: const Icon(CupertinoIcons.delete, size: 22),
              onPressed: () async {
                var res = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Delete').bold().fontSize(18),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(CupertinoIcons.delete, size: 38, color: Colors.red),
                          ],
                        ).padding(top: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text('Are you sure to delete $firstName $lastName').bold()
                              .fontSize(16),
                            ),
                          ],
                        ).padding(top: 20),
                      ],
                    ).width(MediaQuery.of(context).size.width),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No"),
                      )
                    ],
                  ),
                );

                if(res == true){
                  context.read<CustomersListCubit>().deleteCustomer(id);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove_red_eye_outlined, size: 22),
              onPressed: () async{
                await Get.to(
                  BlocProvider(
                    create: (_) => CustomerViewCubit(id: id, customerUseCase: context.read<CustomersListCubit>().customerUseCase),
                    child: CustomerView(),
                  ),
                );
                await context.read<CustomersListCubit>().updateCustomer(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
