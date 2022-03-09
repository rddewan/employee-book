
import 'package:employee_book/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

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

  void addAddress() {}
}