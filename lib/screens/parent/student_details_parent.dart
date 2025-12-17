import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentStudentDetailsPage extends StatelessWidget {
  final String studentId;

  const ParentStudentDetailsPage({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Student not found'));
          }

          final student =
              snapshot.data!.data() as Map<String, dynamic>;

          final String busId = student['busId'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _studentProfile(student),
                const SizedBox(height: 16),
                _studentInfo(student),
                const SizedBox(height: 16),
                _busInfo(busId),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================================================
  // STUDENT PROFILE CARD
  // ==================================================
  Widget _studentProfile(Map<String, dynamic> student) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              student['name'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(student['village'] ?? ''),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // STUDENT INFO
  // ==================================================
  Widget _studentInfo(Map<String, dynamic> student) {
    return _infoCard(
      title: 'Student Information',
      children: [
        _infoRow('Parent Name', student['parentName'] ?? ''),
        _infoRow('Parent Email', student['parentEmail'] ?? ''),
        _infoRow('Village', student['village'] ?? ''),
      ],
    );
  }

  // ==================================================
  // BUS + DRIVER INFO
  // ==================================================
  Widget _busInfo(String busId) {
    if (busId.isEmpty) {
      return const Text('Bus not assigned');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('buses')
          .doc(busId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Bus data not available');
        }

        final bus =
            snapshot.data!.data() as Map<String, dynamic>;

        final driverId = bus['driverId'] ?? '';

        return Column(
          children: [
            _infoCard(
              title: 'Bus Information',
              children: [
                _infoRow('Bus Number', bus['busNumber'] ?? ''),
                _infoRow('Capacity', bus['capacity'].toString()),
              ],
            ),
            const SizedBox(height: 12),
            _driverInfo(driverId),
          ],
        );
      },
    );
  }

  // ==================================================
  // DRIVER INFO
  // ==================================================
  Widget _driverInfo(String driverId) {
    if (driverId.isEmpty) {
      return const Text('Driver not assigned');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Driver data not available');
        }

        final driver =
            snapshot.data!.data() as Map<String, dynamic>;

        return _infoCard(
          title: 'Driver Information',
          children: [
            _infoRow('Name', driver['name'] ?? ''),
            _infoRow('Phone', driver['phone'] ?? ''),
            _infoRow('License', driver['licenseNumber'] ?? ''),
          ],
        );
      },
    );
  }

  // ==================================================
  // COMMON INFO CARD
  // ==================================================
  Widget _infoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
