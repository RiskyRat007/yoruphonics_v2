import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class ResearcherDashboardScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  ResearcherDashboardScreen({super.key});

  void _exportData(BuildContext context, List<QueryDocumentSnapshot> docs) {
    // Generate CSV
    StringBuffer csv = StringBuffer();
    csv.writeln(
      'ID,Name,Gender,Location,PhonicsScore,PhonicsTime,ComprehensionScore,ComprehensionTime',
    );
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      csv.writeln(
        '${doc.id},${data['name']},${data['gender']},${data['schoolLocation']},${data['phonicsScore']},${data['phonicsTimeMs']},${data['comprehensionScore']},${data['comprehensionTimeMs']}',
      );
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Full Database'),
        content: SingleChildScrollView(child: SelectableText(csv.toString())),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

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
      body: StreamBuilder<QuerySnapshot>(
        stream: studentsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          int totalStudents = docs.length;
          int urban = 0;
          int semiUrban = 0;
          int male = 0;
          int female = 0;

          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;
            if (data['schoolLocation'] == 'Urban') urban++;
            if (data['schoolLocation'] == 'Semi-Urban') semiUrban++;
            if (data['gender'] == 'Male') male++;
            if (data['gender'] == 'Female') female++;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.science, size: 80, color: Colors.purple),
                const SizedBox(height: 20),
                const Text(
                  'Research Analytics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildStatCard(
                  'Total Students',
                  totalStudents.toString(),
                  Colors.blue,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Urban',
                        urban.toString(),
                        Colors.orange,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Semi-Urban',
                        semiUrban.toString(),
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Male',
                        male.toString(),
                        Colors.teal,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Female',
                        female.toString(),
                        Colors.teal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _exportData(context, docs),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.download),
                  label: Text('Export All Data'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
