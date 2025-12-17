import 'package:flutter/material.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

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
            onPressed: () {
              // Later: Language selection
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Later: Firebase logout
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- STUDENT CARD ----------------
            _studentCard(),

            const SizedBox(height: 16),

            // ---------------- QUICK ACTIONS ----------------
            _quickActions(),

            const SizedBox(height: 16),

            // ---------------- FEES SUMMARY ----------------
            _feesSummaryCard(),

            const SizedBox(height: 16),

            // ---------------- BUS INFO ----------------
            _busInfoCard(),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // STUDENT CARD
  // ==================================================
  Widget _studentCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Student Photo
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 30),
            ),

            const SizedBox(width: 12),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rohan Patil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Village: Hingoli'),
                  Text('Bus: MH-20-AB-1234'),
                ],
              ),
            ),

            // View Button
            TextButton(
              onPressed: () {
                // Navigate to student details
              },
              child: const Text('View'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // QUICK ACTION BUTTONS
  // ==================================================
  Widget _quickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _actionButton(Icons.currency_rupee, 'Fees'),
        _actionButton(Icons.directions_bus, 'Bus Info'),
        _actionButton(Icons.receipt_long, 'Receipts'),
        _actionButton(Icons.message, 'Messages'),
      ],
    );
  }

  Widget _actionButton(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate later
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // FEES SUMMARY CARD
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
          children: [
            const Text(
              'Fees Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Pending: ₹1200'),
            const Text('Paid: ₹3600'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Navigate to fees page
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // BUS INFO CARD
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
          children: [
            const Text(
              'Bus Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Bus No: MH-20-AB-1234'),
            const Text('Driver: Ganesh Sir'),
            const Text('Phone: 9XXXXXXXXX'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to bus details
              },
              child: const Text('View Full Details'),
            ),
          ],
        ),
      ),
    );
  }
}
