import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomCaptureButton extends StatelessWidget {
  const CustomCaptureButton({super.key,required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(39),
            color: CupertinoColors.white,
          ),
          height: 80,
          width: 80,
        ),
        Positioned(
          top: 4,
          bottom: 4,
          right: 4,
          left: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.black,
            ),
            height: 65,
            width: 65,
          ),
        ),
        Positioned(
          top: 9,
          bottom: 9,
          right: 9,
          left: 9,
          child: FloatingActionButton(
            onPressed: onPressed,
            shape: CircleBorder(
              side: BorderSide(color: Colors.white, width: 4),
            ),
            elevation: 2,
            child: Icon(Icons.camera),
          ),
        ),

      ],
    );
  }
}
