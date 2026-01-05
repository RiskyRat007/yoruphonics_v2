import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import 'auth/role_selection_screen.dart';
import 'home_screen.dart';
import 'teacher_dashboard.dart';
import 'researcher_dashboard.dart';
import 'auth/pupil_login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // No user logged in
    if (user == null) {
      return const RoleSelectionScreen();
    }

    // If user exists but role not assigned yet
    if (user.role == null || user.role!.isEmpty) {
      return const HomeScreen();
    }

    // Route based on role
    switch (user.role) {
      case 'pupil':
        return const PupilLoginScreen();
      case 'teacher':
        return const TeacherDashboardScreen();
      case 'researcher':
        return const ResearcherDashboardScreen();
      default:
        return const HomeScreen();
    }
  }
}
