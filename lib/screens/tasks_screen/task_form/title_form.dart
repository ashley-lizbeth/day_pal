import 'package:flutter/material.dart';

class TitleForm extends StatefulWidget {
  final TextEditingController controller;
  const TitleForm({super.key, required this.controller});

  @override
  State<TitleForm> createState() => _TitleFormState();
}

class _TitleFormState extends State<TitleForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title*",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Untitled"),
          validator: (title) {
            if (title == null || title.isEmpty) {
              return "Title can't be empty";
            }
            return null;
          },
        ),
      ],
    );
  }
}
