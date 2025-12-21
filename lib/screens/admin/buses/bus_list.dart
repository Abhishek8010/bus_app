import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusListPage extends StatelessWidget {
  const BusListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buses'),
      ),

      // ➕ ADD BUS BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-bus');
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buses')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          // 1️⃣ Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2️⃣ Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No buses added yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final buses = snapshot.data!.docs;

          // 3️⃣ Bus list
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final doc = buses[index];
              final data = doc.data() as Map<String, dynamic>;

              final busNumber = data['busNumber'] ?? 'N/A';
              final capacity = data['capacity'] ?? 0;
              final isActive = data['isActive'] ?? true;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/bus-details',
                    arguments: doc.id,
                  );
                },

                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 🚌 ICON
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.directions_bus,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 📄 BUS INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Bus Number
                              Text(
                                busNumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Capacity
                              Text(
                                'Capacity: $capacity students',
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 6),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isActive
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ➡️ Arrow
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
