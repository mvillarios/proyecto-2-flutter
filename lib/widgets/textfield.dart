import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String labelText, bool isPassword) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelText),
      TextField(
        controller: controller,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.blue,
            ),
          ),
          contentPadding: EdgeInsets.all(10),
        ),
        obscureText: isPassword,
      ),
      const SizedBox(height: 10),
    ],
  );
}