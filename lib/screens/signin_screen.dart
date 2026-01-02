import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakWelcome();
  }

  Future<void> _speakWelcome() async {
    await _tts.setLanguage(
      "en-NG",
    ); // Nigerian English (falls back if not available)
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.speak("Choose your role: pupil, teacher, or researcher.");
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🐢 Mascot
              Image.asset('assets/ijapamascot.png', height: 160),
              const SizedBox(height: 20),

              // 🏫 Title
              Text(
                "Welcome to YoruPhonics",
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Text(
                "Please sign in as:",
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // 👧 Pupil Button
              ElevatedButton.icon(
                onPressed: () {
                  _tts.speak("Good choice! Let's start learning phonics!");
                  Navigator.pushNamed(context, '/phonics');
                },
                icon: const Icon(Icons.child_care),
                label: const Text("Pupil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),

              // 👩‍🏫 Teacher Button
              ElevatedButton.icon(
                onPressed: () {
                  _tts.speak("Welcome teacher! Let’s view your dashboard.");
                  Navigator.pushNamed(context, '/teacher-dashboard');
                },
                icon: const Icon(Icons.school),
                label: const Text("Teacher"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),

              // 🧩 Admin / Researcher Button
              ElevatedButton.icon(
                onPressed: () {
                  _tts.speak("Welcome researcher! Let’s review the data.");
                  Navigator.pushNamed(context, '/home');
                },
                icon: const Icon(Icons.manage_accounts),
                label: const Text("Admin / Researcher"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Ijapa will guide you through your lessons 🐢",
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
