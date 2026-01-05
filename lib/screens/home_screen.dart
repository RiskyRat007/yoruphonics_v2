import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import 'phonics_module.dart';
import 'comprehension_module.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _playWelcome();
  }

  Future<void> _playWelcome() async {
    await Future.delayed(const Duration(seconds: 1)); // Small delay
    await _tts.setLanguage("en-NG");
    await _tts.setPitch(1.0);
    // "E kaabo" is Yoruba for Welcome.
    await _tts.speak("Welcome! E káàbọ!");
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final String displayName = user?.name ?? 'Friend';
    final String studentId = user?.uid ?? 'unknown';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          'YoruPhonics Home',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/ijapamascot.png', height: 180),
              const SizedBox(height: 30),
              Text(
                'Welcome, $displayName!',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 26,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Learn, listen, and grow your reading skills in English and Yoruba.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/role-selection');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
