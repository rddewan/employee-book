
import 'package:employee_book/noifier/employee_change_notifier.dart';
import 'package:employee_book/screen/employee_future.dart';
import 'package:employee_book/screen/employee_notifier_future.dart';
import 'package:employee_book/screen/employee_notifier_stream.dart';
import 'package:employee_book/screen/employee_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index  = 0;
  //late AppDb _db;
  final pages = const [
    EmployeeNotifierFutureScreen(),
    EmployeeNotifierStreamScreen()
    //EmployeeStreamScreen()
  ];

  @override
  void initState() {
    super.initState();

    //_db = AppDb();

  }
@override
  void dispose() {
    //_db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: pages[index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_employee');
        }, 
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          if (value == 1) {
            context.read<EmployeeChangeNotifier>().getEmployeeStream();
          }
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.blue.shade300,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Future'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Stream'
          )
        ]),
    );
  }
}

