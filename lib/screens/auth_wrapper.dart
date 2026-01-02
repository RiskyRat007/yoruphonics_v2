import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import 'auth/role_selection_screen.dart';
import 'home_screen.dart';
import 'teacher_dashboard.dart';
import 'researcher_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // If not logged in, show Role Selection (or Login)
    if (user == null) {
      return const RoleSelectionScreen();
    }

    // Role-based routing
    if (user.role == 'teacher') {
      return TeacherDashboardScreen();
    } else if (user.role == 'researcher') {
      return ResearcherDashboardScreen();
    } else {
      // Default to pupil (HomeScreen)
      return HomeScreen();
    }
  }
}
