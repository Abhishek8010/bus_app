import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_app/screens/parent/student_details_parent.dart';
import 'package:bus_app/screens/parent/parent_fees.dart ';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  String? parentUid;

  @override
  void initState() {
    super.initState();
    parentUid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        title: const Text(
          'Pandurang Krupa School Bus',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: parentUid == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(parentUid)
                  .snapshots(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('Parent data not found'),
                  );
                }

                final userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                final List studentIds =
                    userData['studentIds'] ?? [];

                // No students assigned
                if (studentIds.isEmpty) {
                  return const Center(
                    child: Text(
                      'No student assigned.\nPlease contact admin.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Main UI
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- STUDENT LIST ----------------
                      _studentList(studentIds),

                      const SizedBox(height: 16),

                      _quickActions(),

                      const SizedBox(height: 16),

                      _feesSummaryCard(),

                      const SizedBox(height: 16),

                      _busInfoCard(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // ==================================================
  // STUDENT LIST (MULTIPLE)
  // ==================================================
  Widget _studentList(List studentIds) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('students')
          .where(FieldPath.documentId, whereIn: studentIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No students found');
        }

        final students = snapshot.data!.docs;

        return Column(
          children: students.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text('Village: ${data['village'] ?? ''}'),
                          Text('Bus ID: ${data['busId'] ?? ''}'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParentStudentDetailsPage(
                              studentId: doc.id,
                            ),
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ==================================================
  // QUICK ACTIONS
  // ==================================================
  Widget _quickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _actionButton(Icons.currency_rupee, 'Fees',const ParentFeesPage()),
        _actionButton(Icons.directions_bus, 'Bus Info',const ParentFeesPage()),
        _actionButton(Icons.receipt_long, 'Receipts',const ParentFeesPage()),
        _actionButton(Icons.message, 'Messages',const ParentFeesPage()),
      ],
    );
  }

  Widget _actionButton(IconData icon, String title, Widget? navigateTo) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () { 
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => navigateTo! ,
              ),
            );

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // FEES SUMMARY (STATIC FOR NOW)
  // ==================================================
  Widget _feesSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Fees Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Pending: ₹1200'),
            Text('Paid: ₹3600'),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // BUS INFO (STATIC FOR NOW)
  // ==================================================
  Widget _busInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Bus Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Bus No: MH-20-AB-1234'),
            Text('Driver: Ganesh Sir'),
            Text('Phone: 9XXXXXXXXX'),
          ],
        ),
      ),
    );
  }
}
