import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  void _exportData(BuildContext context, List<QueryDocumentSnapshot> docs) {
    // Generate CSV String
    StringBuffer csv = StringBuffer();
    csv.writeln('ID,Name,Gender,Location,Phonics,Comprehension');
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      csv.writeln(
        '${doc.id},${data['name'] ?? ''},${data['gender'] ?? ''},${data['schoolLocation'] ?? ''},${data['phonicsScore'] ?? 0},${data['comprehensionScore'] ?? 0}',
      );
    }

    // For now, show in a dialog as "Export"
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Data (CSV)'),
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
      appBar: AppBar(title: Text('Teacher Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Class Progress Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _exportData(context, students),
                      icon: Icon(Icons.download),
                      label: Text('Export CSV'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var doc = students[index];
                      var data = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('${data['name'] ?? 'Unknown'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phonics Score: ${data['phonicsScore'] ?? '-'}',
                              ),
                              Text(
                                'Comprehension Score: ${data['comprehensionScore'] ?? '-'}',
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
