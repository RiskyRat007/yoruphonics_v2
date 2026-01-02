import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ResearcherDashboardScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  ResearcherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Researcher Dashboard'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.science, size: 80, color: Colors.purple),
            const SizedBox(height: 20),
            const Text(
              'Research Data & Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Charts and data export tools will go here.'),
          ],
        ),
      ),
    );
  }
}
