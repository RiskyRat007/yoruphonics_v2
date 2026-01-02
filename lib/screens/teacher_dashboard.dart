import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students = [
    {
      'id': 'P-101',
      'name': 'Student A',
      'phonicsScore': 80,
      'comprehensionScore': 70,
    },
    {
      'id': 'P-102',
      'name': 'Student B',
      'phonicsScore': 90,
      'comprehensionScore': 85,
    },
    {
      'id': 'P-103',
      'name': 'Student C',
      'phonicsScore': 75,
      'comprehensionScore': 65,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Class Progress Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  var student = students[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${student['name']} (${student['id']})'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phonics Score: ${student['phonicsScore']}'),
                          Text(
                            'Comprehension Score: ${student['comprehensionScore']}',
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
