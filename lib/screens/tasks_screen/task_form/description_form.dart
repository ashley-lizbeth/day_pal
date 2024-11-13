import 'package:flutter/material.dart';

class DescriptionForm extends StatefulWidget {
  final TextEditingController controller;
  const DescriptionForm({super.key, required this.controller});

  @override
  State<DescriptionForm> createState() => _DescriptionFormState();
}

class _DescriptionFormState extends State<DescriptionForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description"),
        TextFormField(
          controller: widget.controller,
          decoration:
              InputDecoration(border: OutlineInputBorder(), hintText: ""),
        ),
      ],
    );
  }
}
