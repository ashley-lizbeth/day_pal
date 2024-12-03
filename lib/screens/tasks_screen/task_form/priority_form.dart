import 'package:day_pal/core/entities/priority.dart';
import 'package:flutter/material.dart';

class PriorityController extends ChangeNotifier {
  Priority value = Priority(Priority.neutral);

  void setValue(Priority p) {
    value = p;
    notifyListeners();
  }
}

class PriorityForm extends StatefulWidget {
  final PriorityController controller;
  const PriorityForm({super.key, required this.controller});

  @override
  State<PriorityForm> createState() => _PriorityFormState();
}

class _PriorityFormState extends State<PriorityForm> {
  late Priority dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.controller.value;

    widget.controller.addListener(() {
      setState(() {
        dropdownValue = widget.controller.value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Priority: ", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 14,
        ),
        DropdownButton<Priority>(
            value: dropdownValue,
            items: Priority.asList()
                .map<DropdownMenuItem<Priority>>((Priority p) =>
                    DropdownMenuItem(
                        value: p, child: Row(children: [p.icon, Text(p.name)])))
                .toList(),
            onChanged: (Priority? p) {
              widget.controller.setValue(p!);
            })
      ],
    );
  }
}
