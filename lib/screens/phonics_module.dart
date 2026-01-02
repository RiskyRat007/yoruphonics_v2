import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhonicsModuleScreen extends StatefulWidget {
  final String studentId;
  const PhonicsModuleScreen({Key? key, required this.studentId})
    : super(key: key);

  @override
  State<PhonicsModuleScreen> createState() => _PhonicsModuleScreenState();
}

class _PhonicsModuleScreenState extends State<PhonicsModuleScreen> {
  final FlutterTts _tts = FlutterTts();
  List<dynamic> _lessons = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/phonics_lessons.json',
    );
    final List<dynamic> data = jsonDecode(jsonString);
    setState(() {
      _lessons = data;
      _isLoading = false;
    });
    await _speakLesson();
  }

  Future<void> _speakLesson() async {
    if (_lessons.isEmpty) return;
    final lesson = _lessons[_currentIndex];
    final message =
        "This is the sound ${lesson['sound']}. In English, ${lesson['english_word']}. "
        "In Yoruba, ${lesson['yoruba_word']}. ${lesson['gesture']}";
    await _tts.setLanguage("en-NG");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(message);
  }

  void _nextLesson() async {
    if (_currentIndex < _lessons.length - 1) {
      setState(() => _currentIndex++);
      await _speakLesson();
    } else {
      await _tts.speak(
        "Excellent work! You have finished all your phonics sounds!",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 All lessons completed!")),
      );
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Phonics Module'),
        backgroundColor: Colors.green.shade700,
=======
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
>>>>>>> f6411abeae0e0b41f577fdacd9bd484d039a89ec
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCircle(color: Colors.green, size: 50),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/ijapamascot.png', height: 150),
                  const SizedBox(height: 20),
                  Text(
                    "Sound: ${_lessons[_currentIndex]['sound'].toUpperCase()}",
                    style: GoogleFonts.fredoka(
                      fontSize: 36,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "English: ${_lessons[_currentIndex]['english_word']}",
                    style: GoogleFonts.notoSans(fontSize: 20),
                  ),
                  Text(
                    "Yoruba: ${_lessons[_currentIndex]['yoruba_word']}",
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Gesture Hint:\n${_lessons[_currentIndex]['gesture']}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _nextLesson,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next Sound"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
