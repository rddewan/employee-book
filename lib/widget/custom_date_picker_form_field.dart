import 'package:flutter/material.dart';

class CustomDatePickerFormFiled extends StatelessWidget {
  final TextEditingController _controller;
  final String _txtLabel;
  final VoidCallback _callback;

  const CustomDatePickerFormFiled(
    {
      Key? key,
      required TextEditingController controller,
      required String txtLabel,
      required VoidCallback callback,
    }) : _controller = controller, _txtLabel = txtLabel, _callback = callback, super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(_txtLabel)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$_txtLabel cannot be empty';
        }
        return null;
      }, 
      onTap: _callback,             
    );
  }
}