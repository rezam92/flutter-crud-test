import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mc_crud_test/application/dependencies/repo_module.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';
import 'package:mc_crud_test/presentation/bloc/list/customers_list_cubit.dart';
import 'package:mc_crud_test/presentation/pages/list/list.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) =>
            CustomersListCubit(CustomerUseCase(customerRepo: RepoModule.getCustomerRepo))
              ..getCustomersList(),
        child: const CustomerListPage(),
      ),
    );
  }
}