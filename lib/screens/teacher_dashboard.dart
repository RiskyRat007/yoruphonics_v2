import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, dynamic>> students = [
    {
      'id': 'P-101',
      'name': 'Amina',
      'phonicsScore': 80,
      'comprehensionScore': 70,
    },
    {
      'id': 'P-102',
      'name': 'Chidi',
      'phonicsScore': 90,
      'comprehensionScore': 85,
    },
    {
      'id': 'P-103',
      'name': 'Tunde',
      'phonicsScore': 75,
      'comprehensionScore': 65,
    },
  ];

  @override
  void initState() {
    super.initState();
    _playIjapaWelcome();
  }

  Future<void> _playIjapaWelcome() async {
    try {
      await _player.play(AssetSource('audio/teacherwelcomeback.mp3'));
    } catch (e) {
      debugPrint('Error playing teacher welcome audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Helper function to compute class averages
  double _calculateAverage(String key) {
    if (students.isEmpty) return 0;
    double total = students.fold(0, (sum, s) => sum + s[key]);
    return (total / students.length);
  }

  @override
  Widget build(BuildContext context) {
    final double avgPhonics = _calculateAverage('phonicsScore');
    final double avgComprehension = _calculateAverage('comprehensionScore');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          'Teacher Dashboard',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐢 Ijapa greeting section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/ijapamascot.png', height: 90),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Ẹ káàbọ̀, Teacher! Let's review your pupils' progress today.",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 📈 Class summary section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard(
                  title: "Phonics Avg",
                  value: "${avgPhonics.toStringAsFixed(1)}%",
                  color: Colors.orange.shade400,
                  icon: Icons.record_voice_over,
                ),
                _buildSummaryCard(
                  title: "Comprehension Avg",
                  value: "${avgComprehension.toStringAsFixed(1)}%",
                  color: Colors.teal.shade400,
                  icon: Icons.book_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🧑🏾‍🏫 Student list title
            Text(
              'Pupil Progress Reports',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🧾 Student list view
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  var student = students[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade300,
                        child: Text(
                          student['name'][0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${student['name']} (${student['id']})',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phonics: ${student['phonicsScore']}%'),
                            Text(
                              'Comprehension: ${student['comprehensionScore']}%',
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Viewing ${student['name']}'s performance",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Footer
            Center(
              child: Text(
                "© 2026 YoruPhonics Teacher Dashboard",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📊 Reusable summary card widget
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 150,
        height: 110,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
