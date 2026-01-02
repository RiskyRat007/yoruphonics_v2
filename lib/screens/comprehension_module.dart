import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mascot_widget.dart';

class ComprehensionModuleScreen extends StatefulWidget {
  final String studentId;
  const ComprehensionModuleScreen({required this.studentId, Key? key})
    : super(key: key);

  @override
  _ComprehensionModuleScreenState createState() =>
      _ComprehensionModuleScreenState();
}

class _ComprehensionModuleScreenState extends State<ComprehensionModuleScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the main idea of the story?',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'answer': 0,
    },
    {
      'question': 'Who is the main character?',
      'options': ['Character A', 'Character B', 'Character C', 'Character D'],
      'answer': 1,
    },
  ];

  int currentQuestionIndex = 0;
  int? selectedOption;

  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Comprehension Module')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MascotWidget(message: currentQuestion['question']),
            SizedBox(height: 20),
            ...List.generate(
              currentQuestion['options'].length,
              (index) => RadioListTile<int>(
                title: Text(currentQuestion['options'][index]),
                value: index,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int score = (selectedOption == currentQuestion['answer'])
                    ? 1
                    : 0;

                await studentsCollection.doc(widget.studentId).set({
                  'comprehensionScore': FieldValue.increment(score),
                  'id': widget.studentId,
                }, SetOptions(merge: true));

                setState(() {
                  if (currentQuestionIndex < questions.length - 1) {
                    currentQuestionIndex++;
                    selectedOption = null;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You completed the module!')),
                    );
                  }
                });
              },
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}
