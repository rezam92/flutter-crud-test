import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mc_crud_test/presentation/bloc/create/create_user_cubit.dart';
import 'package:mc_crud_test/presentation/bloc/list/customers_list_cubit.dart';
import 'package:mc_crud_test/presentation/pages/create/create.dart';
import 'package:mc_crud_test/presentation/widgets/list_item_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final RefreshController controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersListCubit, CustomersListState>(builder: (context, state) {
      if (state is CustomersListLoaded) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              var res = await Get.to(
                () => BlocProvider(
                  create: (_) => CreateCustomerCubit(context.read<CustomersListCubit>().customerUseCase),
                  child: const CreateCustomer(),
                ),
              );
              if (res == true) {
                context.read<CustomersListCubit>().getCustomersList();
              }
            },
          ),
          body: SafeArea(
            child: SmartRefresher(
              controller: controller,
              onRefresh: () async {
                await context.read<CustomersListCubit>().getCustomersList();
                controller.refreshCompleted();
              },
              onLoading: () {},
              child: state.list.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.list, size: 26),
                            const SizedBox(width: 15),
                            const Text("The customers list is empty").fontSize(18).bold(),
                          ],
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: state.list.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      itemBuilder: (_, index) {
                        final item = state.list[index];
                        return ListItemWidget(firstName: item.firstName, lastName: item.lastName, id: item.id!).padding(bottom: 10);
                      },
                    ),
            ),
          ),
        );
      }

      if (state is CustomersListError) {
        return const Scaffold(
          body: Center(
            child: Text('Error'),
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
