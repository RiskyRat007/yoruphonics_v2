import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/mascot_widget.dart';
import '../services/sound_service.dart';

class ComprehensionModuleScreen extends StatefulWidget {
  final String studentId;
  const ComprehensionModuleScreen({required this.studentId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComprehensionModuleScreenState createState() =>
      _ComprehensionModuleScreenState();
}

class _ComprehensionModuleScreenState extends State<ComprehensionModuleScreen> {
  final FlutterTts _tts = FlutterTts();
  final SoundService _soundService = SoundService();
  final String passage =
      "Ijapa goes to the market. He sees many friends. He buys yams and pepper. Ijapa is happy.";

  // Example passage translation for TTS if needed, or just reading English.
  // PRD says: "Displays short passage in English with Yoruba TTS translation."
  // So we should try to read it in Yoruba? But I don't have Yoruba text.
  // I will assume TTS should read English, or maybe attempt Yoruba if the text was provided.
  // Given I only have English text, I will read it in English for now, or just say 'Yoruba translation would play here'.
  // Actually, let's stick to reading the English passage as that's what's visible.

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Where does Ijapa go?',
      'options': ['School', 'Market', 'Farm', 'River'],
      'answer': 1,
    },
    {
      'question': 'What does he buy?',
      'options': ['Beans', 'Rice', 'Yams and Pepper', 'Bread'],
      'answer': 2,
    },
  ];

  int currentQuestionIndex = 0;
  int? selectedOption;
  final Stopwatch _stopwatch = Stopwatch();
  int score = 0;

  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _tts.stop();
    _soundService.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> _finishModule() async {
    _stopwatch.stop();
    await studentsCollection.doc(widget.studentId).set({
      'comprehensionScore': score,
      'comprehensionTimeMs': _stopwatch.elapsedMilliseconds,
      'lastComprehensionDate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Module Complete! Score: $score/${questions.length}'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Comprehension Module')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Passage Section
              Card(
                elevation: 4,
                color: Colors.orange[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Passage",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        passage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, height: 1.5),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _speak(passage),
                        icon: Icon(Icons.volume_up),
                        label: Text('Read Aloud'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),

              // Question Section
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
                onPressed: selectedOption == null
                    ? null
                    : () async {
                        // Check answer
                        if (selectedOption == currentQuestion['answer']) {
                          score++;
                          _soundService.playAsset(SoundService.excellent);
                        } else {
                          _soundService.playAsset(SoundService.tryAgain);
                        }

                        if (currentQuestionIndex < questions.length - 1) {
                          setState(() {
                            currentQuestionIndex++;
                            selectedOption = null;
                          });
                        } else {
                          _finishModule();
                        }
                      },
                child: Text(
                  currentQuestionIndex < questions.length - 1
                      ? 'Next Question'
                      : 'Finish',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
