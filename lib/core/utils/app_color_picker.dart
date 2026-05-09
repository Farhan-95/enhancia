import 'package:enhancia/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

void pickColor(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  Color currentColor = themeProvider.appBarColor;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Pick AppBar Color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: currentColor,
          onColorChanged: (color) {
            currentColor = color;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Select"),
          onPressed: () {
            themeProvider.setCustomAppbarColor(currentColor);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
