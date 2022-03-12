import 'package:employee_book/data/local/db/app_db.dart';
import 'package:employee_book/noifier/employee_address_change_notifier.dart';
import 'package:employee_book/noifier/employee_change_notifier.dart';
import 'package:employee_book/widget/custom_date_picker_form_field.dart';
import 'package:employee_book/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class EditEmployeeScreen extends StatefulWidget {
  final int id;
  const EditEmployeeScreen({required this.id, Key? key}) : super(key: key);

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
  
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late EmployeeData _employeeData;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;
  late EmployeeChangeNotifier _employeeChangeNotifier;
  int _isActive = 0;
  int _id = 0;
  

  @override
  void initState() {    
    super.initState();
    _employeeChangeNotifier = Provider.of<EmployeeChangeNotifier>(context,listen: false);  
    _employeeChangeNotifier.addListener(providerListener);
    //getEmployee();      
  }

  @override
  void dispose() {    
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();   
    //_employeeChangeNotifier.dispose(); 
    _employeeChangeNotifier.removeListener(providerListener);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              editEmployee();
            }, 
            icon: const Icon(Icons.save)
          ),
          IconButton(
            onPressed: () {
              deleteEmployee();
            }, 
            icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Selector<EmployeeChangeNotifier,EmployeeData?>(
              selector: (context,notifier) => notifier.employeeData,
              builder: (context,data,child) {
                setEmployee(data);
                return Form(
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
                    Selector<EmployeeChangeNotifier, bool>(
                      selector: (context,notifier) => notifier.isActive,
                      builder: (context,value,child) {
                        _isActive = value ? 1 : 0;
                        return CheckboxListTile(
                          title: const Text('isActive'),
                          activeColor: Colors.pink,
                          value: value, 
                          onChanged: (value) {
                            context.read<EmployeeChangeNotifier>().setIsActive(value ?? false);                        
                          },
                        );

                      },                      
                    ),                        
                    ],
                  )
                );           

              },
            ),
            const  SizedBox(height: 16.0,),
            Expanded(
              child: Selector<EmployeeAddressChangeNotifier,List<emp_address>>(
                selector: (context,notifier) => notifier.employeeList,
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
            ),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_address', arguments: _id);
        }, 
        label: const Text('Address'),
        icon: const Icon(Icons.add)
      ),
    );
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context, 
      initialDate:  _dateOfBirth ?? initialDate, 
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
      _dateOfBirth = newDate;
      String dob = DateFormat('dd/MM/yyyy').format(newDate);
      _dateOfBirthController.text = dob;
    });

  }
 
  void editEmployee(){
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
          final entity = EmployeeCompanion(
      id: drift.Value(widget.id),
      userName: drift.Value(_userNameController.text),
      firstName: drift.Value(_firstNameController.text),
      lastName: drift.Value(_lastNameController.text),
      dateOfBirth: drift.Value(_dateOfBirth!),
      isActive: drift.Value(_isActive),
    );

    context.read<EmployeeChangeNotifier>().updateEmployee(entity);

    // Provider.of<AppDb>(context, listen: false).updateEmployee(entity).then((value) => ScaffoldMessenger.of(context)
    //   .showMaterialBanner(
    //     MaterialBanner(
    //       backgroundColor: Colors.pink,
    //       content: Text('Employee updated : $value',style: const TextStyle(color: Colors.white)), 
    //       actions: [
    //         TextButton(
    //           onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
    //           child: const Text('Close',style: TextStyle(color: Colors.white),))
    //       ],
    //     ),
    //     ),
    //   );
    }
  }

  void deleteEmployee(){
    context.read<EmployeeChangeNotifier>().deleteEmployee(widget.id);
    // Provider.of<AppDb>(context, listen: false).deleteEmployee(widget.id).then((value) =>ScaffoldMessenger.of(context)
    // .showMaterialBanner(
    //   MaterialBanner(
    //     backgroundColor: Colors.pink,
    //     content: Text('Employee deleted : $value',style: const TextStyle(color: Colors.white)), 
    //     actions: [
    //       TextButton(
    //         onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
    //         child: const Text('Close',style: TextStyle(color: Colors.white),))
    //     ],
    //   ),
    // ),
    // );

  }

  void providerListener(){
    if (_employeeChangeNotifier.isUpdated) {
      listenUpdate();
    }
    if (_employeeChangeNotifier.isDeleted) {
      listenDelete();
    }
    if (_employeeChangeNotifier.error != '') {
      listenError(_employeeChangeNotifier.error);
    }
  }

  void listenDelete() {
    ScaffoldMessenger.of(context)
    .showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.pink,
        content: const Text('Employee deleted ',style:  TextStyle(color: Colors.white)), 
        actions: [
          TextButton(
            onPressed: ()  {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              context.read<EmployeeChangeNotifier>().setIsDeleted(false);
            }, 
            child: const Text('Close',style: TextStyle(color: Colors.white),))
        ],
      ),
    );
    
  }

  void listenUpdate(){
    ScaffoldMessenger.of(context)
      .showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.pink,
          content: const Text('Employee updated ',style:  TextStyle(color: Colors.white)), 
          actions: [
            TextButton(
              onPressed: () {
                 ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                 context.read<EmployeeChangeNotifier>().setIsUpdated(false);
              }, 
              child: const Text('Close',style: TextStyle(color: Colors.white),))
          ],
        ),
      );
  }

  void listenError(String errorMsg){
    ScaffoldMessenger.of(context)
      .showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.pink,
          content: Text(errorMsg,style: const TextStyle(color: Colors.white)), 
          actions: [
            TextButton(
              onPressed: () {
                 ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                 context.read<EmployeeChangeNotifier>().setErrorMsg('');
              }, 
              child: const Text('Close',style: TextStyle(color: Colors.white),))
          ],
        ),
      );
  }

  void setEmployee(EmployeeData? data) {   
    if (data != null) {
       _userNameController.text = data.userName;
      _firstNameController.text = data.firstName;
      _lastNameController.text = data.lastName;
      _dateOfBirthController.text = data.dateOfBirth.toIso8601String();
      _id = data.id;
      

    } 
   


  }
  
  Future<void> getEmployee() async {
    _employeeData = await Provider.of<AppDb>(context, listen: false).getEmployee(widget.id);
    _userNameController.text = _employeeData.userName;
    _firstNameController.text = _employeeData.firstName;
    _lastNameController.text = _employeeData.lastName;
    _dateOfBirthController.text = _employeeData.dateOfBirth.toIso8601String();

  }

  
}

