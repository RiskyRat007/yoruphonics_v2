import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/mascot_widget.dart';
import '../services/sound_service.dart';

class PhonicsModuleScreen extends StatefulWidget {
  final String studentId;
  const PhonicsModuleScreen({required this.studentId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhonicsModuleScreenState createState() => _PhonicsModuleScreenState();
}

class _PhonicsModuleScreenState extends State<PhonicsModuleScreen> {
  final FlutterTts _tts = FlutterTts();
  final SoundService _soundService = SoundService();
  final List<String> sounds = ['a', 'b', 's', 't', 'sh', 'ch'];
  int currentIndex = 0;
  bool isQuizMode = false;
  int quizScore = 0;
  final Stopwatch _stopwatch = Stopwatch();
  List<String> currentOptions =
      []; // Store options to prevent reshuffle on rebuild

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

  void _finishModule() async {
    _stopwatch.stop();
    // Save results
    await studentsCollection.doc(widget.studentId).set({
      'phonicsScore': quizScore,
      'phonicsTimeMs': _stopwatch.elapsedMilliseconds,
      'lastPhonicsDate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Module Complete! Score: $quizScore')),
      );
      Navigator.pop(context);
    }
  }

  void _generateQuizOptions() {
    String correct = sounds[currentIndex];
    Set<String> optionsSet = {correct};
    while (optionsSet.length < 3) {
      optionsSet.add((sounds.toList()..shuffle()).first);
    }
    currentOptions = optionsSet.toList()..shuffle();
  }

  void _nextStep() {
    setState(() {
      if (!isQuizMode) {
        // In Learning Mode
        if (currentIndex < sounds.length - 1) {
          currentIndex++;
        } else {
          // Switch to Quiz Mode
          isQuizMode = true;
          currentIndex = 0;
          _generateQuizOptions();
        }
      } else {
        // In Quiz Mode
        if (currentIndex < sounds.length - 1) {
          currentIndex++;
          _generateQuizOptions();
        } else {
          _finishModule();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentSound = sounds[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(isQuizMode ? 'Phonics Quiz' : 'Learn Sounds')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MascotWidget(
              message: isQuizMode
                  ? 'Which sound matches the letter?'
                  : 'Listen to the sound of "$currentSound".',
            ),
            SizedBox(height: 20),
            if (!isQuizMode) ...[
              // Learning Mode
              Text(
                currentSound,
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _speak(currentSound),
                icon: Icon(Icons.volume_up),
                label: Text('Play Sound'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _nextStep,
                child: Text(
                  currentIndex < sounds.length - 1
                      ? 'Next Sound'
                      : 'Start Quiz',
                ),
              ),
            ] else ...[
              // Quiz Mode
              // Simple quiz: Show sound string, ask user to confirm they know it?
              // Or better: Play sound, select correct text.
              // Let's do: Play sound, user selects from options.
              Spacer(),
              IconButton(
                iconSize: 64,
                icon: Icon(Icons.volume_up_rounded, color: Colors.teal),
                onPressed: () => _speak(currentSound),
              ),
              Text(
                "Tap to hear the sound",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30),
              Wrap(
                spacing: 20,
                children: currentOptions.map((opt) {
                  return ElevatedButton(
                    onPressed: () {
                      if (opt == currentSound) {
                        // Correct
                        _soundService.playAsset(SoundService.excellent);
                        quizScore++;
                      } else {
                        _soundService.playAsset(SoundService.tryAgain);
                      }
                      _nextStep();
                    },
                    child: Text(opt, style: TextStyle(fontSize: 24)),
                  );
                }).toList(),
              ),
            ],
            Spacer(),
          ],
        ),
      ),
    );
  }
}
