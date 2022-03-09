
import 'package:employee_book/screen/add_address.dart';
import 'package:employee_book/screen/add_employee_screen.dart';
import 'package:employee_book/screen/edit_employee_screen.dart';
import 'package:employee_book/screen/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/add_employee':
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen()); 
       case '/edit_employee':
        if (args is int) {
          return MaterialPageRoute(builder: (_) =>  EditEmployeeScreen(id: args)); 
        }
        return _errorRoute(); 
        case '/add_address':
        if (args is int) {
          return MaterialPageRoute(builder: (_) =>  AddAddress(id: args)); 
        }
        return _errorRoute();          
      default:
        return _errorRoute();
    }

  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Route'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Sorry no route was found!', style: TextStyle(color: Colors.red, fontSize: 18.0)),
        ),
      );
    });
  }
}