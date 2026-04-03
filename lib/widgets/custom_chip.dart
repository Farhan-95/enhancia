import 'package:flutter/material.dart';

Widget buildChip(Widget label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3), // Semi-transparent black
      borderRadius: BorderRadius.circular(70),
    ),
    child:label
  );
}