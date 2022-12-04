import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlusButton extends StatelessWidget {
  final function;

  const PlusButton({super.key, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: function,
        child: Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[500],
          ),
          child: Center(
            child: Text(
              '+',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          // ),
        ));
  }
}
