import 'package:employee_book/data/local/db/app_db.dart';
import 'package:employee_book/widget/custom_date_picker_form_field.dart';
import 'package:employee_book/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
  
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBith;

  @override
  void initState() {    
    super.initState();    
  }

  @override
  void dispose() {    
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {              
              addEmployee();
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
                CustomTextFormField(controller: _userNameController, txtLable: 'User Name',),
                const SizedBox(height: 8.0,),
                CustomTextFormField(controller: _firstNameController, txtLable: 'First Name',),
                const SizedBox(height: 8.0,),
                CustomTextFormField(controller: _lastNameController, txtLable: 'Last Name',),
                const SizedBox(height: 8.0,),
                CustomDatePickerFormFiled(
                  controller: _dateOfBirthController, txtLabel: 'Date of birth', callback: () {
                    pickDateOfBirth(context);
                  }),
                const SizedBox(height: 8.0,),    
                ],
              )
            ),
                 
          ],

        ),
      ),
    );
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context, 
      initialDate:  _dateOfBith ?? initialDate, 
      firstDate: DateTime(DateTime.now().year - 100), 
      lastDate: DateTime(DateTime.now().year  + 1),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.pink,
            onPrimary: Colors.white,
            onSurface: Colors.black
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(''),
      )      
    );

    if (newDate == null) {
      return;
    }

    setState(() {
      _dateOfBith = newDate;
      String dob = DateFormat('dd/MM/yyyy').format(newDate);
      _dateOfBirthController.text = dob;
    });

  }
 
  void addEmployee(){
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
      userName: drift.Value(_userNameController.text),
      firstName: drift.Value(_firstNameController.text),
      lastName: drift.Value(_lastNameController.text),
      dateOfBirth: drift.Value(_dateOfBith!),
      );

      Provider.of<AppDb>(context, listen: false).insertEmployee(entity).then((value) => ScaffoldMessenger.of(context)
          .showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.pink,
              content: Text('New employee inserted: $value',style: const TextStyle(color: Colors.white)), 
              actions: [
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
                  child: const Text('Close',style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        );      
    }  
  }
}

