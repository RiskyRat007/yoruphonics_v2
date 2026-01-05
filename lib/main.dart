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
import 'screens/researcher_dashboard.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth_wrapper.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const YoruPhonicsApp());
}

class YoruPhonicsApp extends StatelessWidget {
  const YoruPhonicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),
      ],
      child: MaterialApp(
        title: 'YoruPhonics v5.1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Noto',
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          'authwrapper': (context) => const AuthWrapper(),
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/phonics': (context) => PhonicsModuleScreen(studentId: 'P-101'),
          '/comprehension': (context) =>
              ComprehensionModuleScreen(studentId: 'P-101'),
          '/teacher-dashboard': (context) => TeacherDashboardScreen(),
          '/researcher-dashboard': (context) => ResearcherDashboardScreen(),
          '/role-selection': (context) => const RoleSelectionScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
