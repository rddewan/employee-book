
import 'package:employee_book/data/local/db/app_db.dart';
import 'package:employee_book/noifier/employee_address_change_notifier.dart';
import 'package:employee_book/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';


class AddAddress extends StatefulWidget {
  const AddAddress({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  late EmployeeAddressChangeNotifier _addressChangeNotifier;

  @override
  void initState() {    
    super.initState();
    _addressChangeNotifier = context.read<EmployeeAddressChangeNotifier>();
    _addressChangeNotifier.addListener(addressListener);
  }

  @override
  void dispose() {
    _countryController.dispose();
    _streetController.dispose();
    _addressChangeNotifier.removeListener(addAddress);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () { 
              addAddress();
            }, 
            icon: const Icon(Icons.save)
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                CustomTextFormField(controller: _streetController, txtLable: 'Street',),
                const SizedBox(height: 8.0,),
                CustomTextFormField(controller: _countryController, txtLable: 'Country',),
                const SizedBox(height: 8.0,),               
                
                ],
              )
            ),
                 
          ],

        ),
      ),
    );
  }

  void addAddress() {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {

      final entity = EmployeeAddressCompanion(
        employee: drift.Value(widget.id),
        street: drift.Value(_streetController.text),
        country: drift.Value(_countryController.text)
      );

      context.read<EmployeeAddressChangeNotifier>().insertAddress(entity);
    }
  }

  void addressListener() {
    if(_addressChangeNotifier.isAdded) {
      ScaffoldMessenger.of(context)
      .showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.pink,
          content: const Text('New address is added',style:  TextStyle(color: Colors.white)), 
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
              child: const Text('Close',style: TextStyle(color: Colors.white),))
          ],
        ),
      );
      
      context.read<EmployeeAddressChangeNotifier>().setIsAdded(false);
    }
    if (_addressChangeNotifier.error != '') {
      ScaffoldMessenger.of(context)
      .showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.pink,
          content: Text(_addressChangeNotifier.error,style: const TextStyle(color: Colors.white)), 
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
              child: const Text('Close',style: TextStyle(color: Colors.white),))
          ],
        ),
      );

      context.read<EmployeeAddressChangeNotifier>().setError();

    }
  }
}