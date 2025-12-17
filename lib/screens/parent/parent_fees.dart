import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentFeesPage extends StatelessWidget {
  const ParentFeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees'),
      ),

      body: parentUid == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(parentUid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData ||
                    !userSnapshot.data!.exists) {
                  return const Center(
                      child: Text('User data not found'));
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final List studentIds =
                    userData['studentIds'] ?? [];

                if (studentIds.isEmpty) {
                  return const Center(
                    child: Text('No students assigned'),
                  );
                }

                return _feesContent(studentIds);
              },
            ),
    );
  }

  // ==================================================
  // MAIN FEES CONTENT
  // ==================================================
  Widget _feesContent(List studentIds) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('fees')
          .where('studentId', whereIn: studentIds)
          .orderBy('month', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No fee records found'),
          );
        }

        final fees = snapshot.data!.docs;

        final pendingFees = fees
            .where((f) => f['status'] == 'pending')
            .toList();

        final paidFees = fees
            .where((f) => f['status'] == 'paid')
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- PENDING FEES ----------------
              const Text(
                'Pending Fees',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              pendingFees.isEmpty
                  ? const Text('No pending fees 🎉')
                  : Column(
                      children: pendingFees.map((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;

                        return _pendingFeeCard(data);
                      }).toList(),
                    ),

              const SizedBox(height: 24),

              // ---------------- PAYMENT HISTORY ----------------
              const Text(
                'Payment History',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              paidFees.isEmpty
                  ? const Text('No payments yet')
                  : Column(
                      children: paidFees.map((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;

                        return _paidFeeCard(data);
                      }).toList(),
                    ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================
  // PENDING FEE CARD
  // ==================================================
  Widget _pendingFeeCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['month'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Amount: ₹${data['amount']}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Payment gateway later
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // PAID FEE CARD
  // ==================================================
  Widget _paidFeeCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['month'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Amount: ₹${data['amount']}'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to receipt page later
              },
              child: const Text('Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
