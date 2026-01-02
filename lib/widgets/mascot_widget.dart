import 'package:flutter/material.dart';

class MascotWidget extends StatelessWidget {
  final String message;

  const MascotWidget({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mascot image
        Image.asset('assets/ijapamascot.png', width: 80, height: 80),
        SizedBox(width: 10),
        // Speech bubble container
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
