import 'package:day_pal/core/entities/status.dart';
import 'package:flutter/material.dart';

class StatusController extends ChangeNotifier {
  Status value = Status(Status.doing);

  void setValue(Status status) {
    value = status;
    notifyListeners();
  }
}

class StatusForm extends StatefulWidget {
  final StatusController controller;
  const StatusForm({super.key, required this.controller});

  @override
  State<StatusForm> createState() => _StatusFormState();
}

class _StatusFormState extends State<StatusForm> {
  late Status dropdownValue;

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
    return Column(
      children: [
        Text("Status"),
        DropdownButton<Status>(
            value: dropdownValue,
            items: Status.asList()
                .map<DropdownMenuItem<Status>>((Status s) => DropdownMenuItem(
                    value: s, child: Row(children: [s.icon, Text(s.name)])))
                .toList(),
            onChanged: (Status? s) {
              widget.controller.setValue(s!);
            })
      ],
    );
  }
}
