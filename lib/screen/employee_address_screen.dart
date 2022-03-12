
import 'package:employee_book/data/local/db/app_db.dart';
import 'package:employee_book/noifier/employee_address_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAddressScreen extends StatelessWidget {
  const EmployeeAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
      ),
      body: Selector<EmployeeAddressChangeNotifier,List<emp_address>>(
        selector: (context,notifier) => notifier.allEmployeeList,
        builder: (context, addressList,child) {
          return ListView.builder(
            itemCount: addressList.length,
            itemBuilder: (context, index){
              final address = addressList[index];

              return ListTile(
                title: Text(address.street),
                subtitle: Text(address.country),
              );

            }
          );
        },
      ),
    );
  }
}