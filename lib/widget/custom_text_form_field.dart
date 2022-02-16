import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,    
    required TextEditingController controller,
    required String txtLable    
  }) : _controller = controller, _txtLable = txtLable, super(key: key);

  final TextEditingController _controller;
  final String _txtLable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(_txtLable)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$_txtLable cannot be empty';
        }
        return null;
      },              
    );
  }
}