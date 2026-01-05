import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PupilLoginScreen extends StatefulWidget {
  const PupilLoginScreen({super.key});

  @override
  State<PupilLoginScreen> createState() => _PupilLoginScreenState();
}

class _PupilLoginScreenState extends State<PupilLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _player = AudioPlayer();

  String pupilId = '';
  String gender = 'Male';
  String schoolLocation = 'Urban';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _playWelcomeAudio();
  }

  Future<void> _playWelcomeAudio() async {
    try {
      await _player.play(AssetSource('audio/ijapa_pupilwelcome.mp3'));
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  Future<void> _savePupilData() async {
    await _firestore.collection('students').doc(pupilId).set({
      'studentId': pupilId,
      'gender': gender,
      'schoolLocation': schoolLocation,
      'loginTime': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text('Pupil Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/ijapamascot.png', height: 120),
                const SizedBox(height: 10),
                Text(
                  "Welcome to YoruPhonics!",
                  style: GoogleFonts.fredoka(
                    fontSize: 26,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Pupil ID
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pupil ID or Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter your ID or name' : null,
                  onChanged: (val) => pupilId = val.trim(),
                ),
                const SizedBox(height: 20),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: gender,
                  items: ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setState(() => gender = val!),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // School Location Dropdown
                DropdownButtonFormField<String>(
                  value: schoolLocation,
                  items: ['Urban', 'Semi-Urban']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => schoolLocation = val!),
                  decoration: InputDecoration(
                    labelText: 'School Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Start Lesson Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = true);
                            await _savePupilData();

                            if (!mounted) return;
                            Navigator.pushReplacementNamed(
                              context,
                              '/home',
                            ); // Go to home screen
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Start Lesson',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
