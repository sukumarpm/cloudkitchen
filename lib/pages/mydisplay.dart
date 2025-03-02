import 'package:flutter/material.dart';

class MyDisplay extends StatelessWidget {
  const MyDisplay(
      {super.key,
      this.size = 16,
      required this.text1,
      required this.text2,
      this.color = Colors.black});
  final double size;
  final Color color;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: TextStyle(fontSize: size, color: color),
          ),
          Text(
            text2,
            style: TextStyle(fontSize: size, color: color),
          )
        ],
      ),
    );
  }
}
