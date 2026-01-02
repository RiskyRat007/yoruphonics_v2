import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yoruphonics_v2/screens/splash_screen.dart';
import 'firebase_options.dart';

// Import your existing app screens
import 'screens/home_screen.dart';
import 'screens/phonics_module.dart';
import 'screens/comprehension_module.dart';
import 'screens/teacher_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const YoruPhonicsApp());
}

class YoruPhonicsApp extends StatelessWidget {
  const YoruPhonicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YoruPhonics v5.1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Noto'),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/phonics': (context) => PhonicsModuleScreen(studentId: 'P-101'),
        '/comprehension': (context) =>
            ComprehensionModuleScreen(studentId: 'P-101'),
        '/teacher-dashboard': (context) => TeacherDashboardScreen(),
      },
    );
  }
}
