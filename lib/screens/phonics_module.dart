import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mascot_widget.dart';

class PhonicsModuleScreen extends StatefulWidget {
  final String studentId; // Required parameter
  const PhonicsModuleScreen({required this.studentId, Key? key})
    : super(key: key);

  @override
  _PhonicsModuleScreenState createState() => _PhonicsModuleScreenState();
}

class _PhonicsModuleScreenState extends State<PhonicsModuleScreen> {
  final List<String> letters = ['A', 'B', 'C', 'D'];
  int currentLetterIndex = 0;

  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  Widget build(BuildContext context) {
    String currentLetter = letters[currentLetterIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Phonics Module')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MascotWidget(message: 'Can you say the sound of $currentLetter?'),
            SizedBox(height: 20),
            Text(
              currentLetter,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                // Log progress to Firestore
                await studentsCollection.doc(widget.studentId).set({
                  'phonicsScore': currentLetterIndex + 1,
                  'id': widget.studentId,
                }, SetOptions(merge: true));

                setState(() {
                  currentLetterIndex =
                      (currentLetterIndex + 1) % letters.length;
                });
              },
              child: Text('Next Letter'),
            ),
          ],
        ),
      ),
    );
  }
}
