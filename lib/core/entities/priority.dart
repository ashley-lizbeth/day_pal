import 'package:flutter/material.dart';

typedef PriorityData = (String, IconData);

const priorityValues = <int, PriorityData>{
  1: ("Urgent", Icons.keyboard_double_arrow_up),
  2: ("Important", Icons.keyboard_arrow_up),
  3: ("Neutral", Icons.minimize),
  4: ("Low priority", Icons.keyboard_arrow_down),
  5: ("Lowest priority", Icons.keyboard_double_arrow_down)
};

PriorityData? getPriorityFromID(int id) {
  return priorityValues[id];
}
