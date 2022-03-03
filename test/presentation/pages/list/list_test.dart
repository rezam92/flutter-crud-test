import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mc_crud_test/application/dependencies/repo_module.dart';
import 'package:mc_crud_test/domain/entities/customre.dart';
import 'package:mc_crud_test/domain/usecases/customers_usecase.dart';
import 'package:mc_crud_test/presentation/bloc/create/create_user_cubit.dart';
import 'package:mc_crud_test/presentation/bloc/list/customers_list_cubit.dart';
import 'package:mc_crud_test/presentation/pages/create/create.dart';
import 'package:mc_crud_test/presentation/pages/list/list.dart';
import 'package:mc_crud_test/presentation/widgets/list_item_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../domain/usecases/customers_usecase_test.mocks.dart';
import 'list_test.mocks.dart';

@GenerateMocks([MockNavigatorObserver])
void main() {
  const customers = [
    Customer(
      id: 1,
      firstName: 'Reza',
      lastName: 'Mahmoudi',
      dateOfBirth: 164985395,
      phoneNumber: '+31634568709',
      email: 'reza@yahoo.com',
      bankAccountNumber: '1467436587435632',
    ),
    Customer(
      id: 2,
      firstName: 'Ali',
      lastName: 'Mahmoudi',
      dateOfBirth: 164985395,
      phoneNumber: '+31634568709',
      email: 'ali@yahoo.com',
      bankAccountNumber: '1467436587435632',
    ),
  ];
  late MockCustomerRepo mockRepository;// = MockCustomerRepo();
  late CustomerUseCase usecase;
  late CustomersListCubit cubit;

  setUp(() {
    mockRepository = MockCustomerRepo();
    usecase = CustomerUseCase(customerRepo: mockRepository);
    cubit = CustomersListCubit(usecase);
  });

  const key = Key('addKey');

  testWidgets('Test Add button', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    when(mockRepository.getCustomers()).thenAnswer((_) async => const Right(customers));
    await tester.pumpWidget(
      GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
          create: (_) => CustomersListCubit(usecase)..getCustomersList(),
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              key: const Key('addKey'),
              child: const Icon(Icons.add),
              onPressed: () async {
                var res = await Get.to(
                      () => BlocProvider(
                    create: (_) => CreateCustomerCubit(usecase),
                    child: const CreateCustomer(),
                  ),
                );
              },
            ),
            body: SafeArea(
              child: SmartRefresher(
                controller: RefreshController(),
                onRefresh: () async {},
                onLoading: () {},
                child: Column(
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
                ),
                ),
              ),
            ),
          ),
        ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    // verifyNever(mockObserver.didPush(any, any));
    expect(find.byType(CreateCustomer), findsOneWidget);

  });
}
