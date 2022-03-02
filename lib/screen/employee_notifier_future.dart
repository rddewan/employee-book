import 'package:employee_book/data/local/db/app_db.dart';
import 'package:employee_book/noifier/employee_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeNotifierFutureScreen extends StatefulWidget {
  const EmployeeNotifierFutureScreen({ Key? key }) : super(key: key);

  @override
  State<EmployeeNotifierFutureScreen> createState() => _EmployeeNotifierFutureScreenState();
}

class _EmployeeNotifierFutureScreenState extends State<EmployeeNotifierFutureScreen> {  
  
  @override
  void initState() {
    super.initState();
  }
@override
  void dispose() {  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BuildContext');
    final isLoading = context.select<EmployeeChangeNotifier,bool>((notifier) => notifier.isLoading);
    final employees = context.select<EmployeeChangeNotifier,List<EmployeeData>>((notifier) => notifier.employeeListFuture);
    return Scaffold(
      appBar: AppBar(
        title: const  Text('Employee Future'),
        centerTitle: true,
      ),
      body: isLoading ? 
        const Center(
          child: CircularProgressIndicator(),
        ) :
        ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
              
              final employee = employees[index];
              return GestureDetector(
                onTap: ()  {
                  Navigator.pushNamed(context, '/edit_employee',arguments: employee.id);
                },
                child: Card(
                //color: Colors.grey.shade400,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    style: BorderStyle.solid,
                    width: 1.2
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0)
                  )

                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.id.toString()),
                      Text(employee.userName.toString(),style: const TextStyle(color: Colors.black),),
                      Text(employee.firstName.toString(),style: const TextStyle(color: Colors.black),),
                      Text(employee.lastName.toString(),style: const TextStyle(color: Colors.black),),
                      Text(employee.dateOfBirth.toString(),style: const TextStyle(color: Colors.black),),
                    ],
                  ),
                ),
              ),
            );
            },
          ),
        
          
      );    
      
   
  }
}

