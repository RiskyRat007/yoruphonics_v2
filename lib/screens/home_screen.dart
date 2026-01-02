import 'package:flutter/material.dart';
import 'phonics_module.dart';
import 'comprehension_module.dart';
import 'teacher_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final String studentId = 'P-101';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YoruPhonics Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ijapamascot.png', width: 150, height: 150),
            SizedBox(height: 20),
            Text(
              'Welcome to YoruPhonics!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              'Choose a module to start:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PhonicsModuleScreen(studentId: studentId),
                  ),
                );
              },
              child: Text('Start Phonics Module'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ComprehensionModuleScreen(studentId: studentId),
                  ),
                );
              },
              child: Text('Start Comprehension Module'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/teacher-dashboard');
              },
              child: Text('Teacher Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
