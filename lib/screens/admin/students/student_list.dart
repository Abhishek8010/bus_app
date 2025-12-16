import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_app/app/routes/app_routes.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        centerTitle: true,
      ),

      // ---------------- ADD STUDENT BUTTON ----------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addStudent);
        },
        child: const Icon(Icons.add),
      ),

      // ---------------- STUDENT LIST ----------------
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No students added yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final doc = students[index];
              final data = doc.data() as Map<String, dynamic>;

              return StudentCard(
                studentId: doc.id,
                name: data['name'] ?? '',
                parentName: data['parentName'] ?? '',
                parentPhone: data['parentPhone'] ?? '',
                busId: data['busId'] ?? '',
                isActive: data['isActive'] ?? true,
              );
            },
          );
        },
      ),
    );
  }
}


class StudentCard extends StatelessWidget {
  final String studentId;
  final String name;
  final String parentName;
  final String parentPhone;
  final String busId;
  final bool isActive;

  const StudentCard({
    super.key,
    required this.studentId,
    required this.name,
    required this.parentName,
    required this.parentPhone,
    required this.busId,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 26,
          backgroundColor: isActive ? Colors.green : Colors.grey,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Parent: $parentName'),
            Text('Phone: $parentPhone'),
            Text('Bus: ${busId.isEmpty ? "Not Assigned" : busId}'),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.studentDetails,
            arguments: studentId,
          );
        },
      ),
    );
  }
}
