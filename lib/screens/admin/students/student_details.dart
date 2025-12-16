import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_app/app/routes/app_routes.dart';


class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // -------- GET STUDENT ID FROM ROUTE --------
    final String studentId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editStudent,
                arguments: studentId,
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .snapshots(),

        builder: (context, snapshot) {
          // -------- LOADING --------
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // -------- ERROR / NOT FOUND --------
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Student not found'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCard(
                  icon: Icons.person,
                  title: 'Student Name',
                  value: data['name'] ?? '',
                ),

                _infoCard(
                  icon: Icons.person_outline,
                  title: 'Parent Name',
                  value: data['parentName'] ?? '',
                ),

                _infoCard(
                  icon: Icons.phone,
                  title: 'Parent Phone',
                  value: data['parentPhone'] ?? '',
                ),

                _infoCard(
                  icon: Icons.location_on,
                  title: 'Village',
                  value: data['village'] ?? '',
                ),

                _infoCard(
                  icon: Icons.directions_bus,
                  title: 'Bus',
                  value:
                      data['busId'] == null || data['busId'].toString().isEmpty
                          ? 'Not Assigned'
                          : data['busId'],
                ),

                _infoCard(
                  icon: Icons.verified_user,
                  title: 'Status',
                  value: data['isActive'] == true ? 'Active' : 'Inactive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------- INFO CARD --------
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
