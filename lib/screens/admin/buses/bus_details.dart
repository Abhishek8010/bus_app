import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusDetailsPage extends StatelessWidget {
  const BusDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive busId from navigation
    final String busId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        actions: [
          // ✏️ EDIT BUTTON
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit-bus',
                arguments: busId,
              );
            },
          ),

          // 🗑 DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, busId),
          ),
        ],
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('buses')
            .doc(busId)
            .get(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error or not found
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Bus not found'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final busNumber = data['busNumber'] ?? 'N/A';
          final capacity = data['capacity'] ?? 0;
          final isActive = data['isActive'] ?? true;
          final routeList = List<String>.from(data['routeList'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🚌 HEADER CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions_bus,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busNumber,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Capacity: $capacity students'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ STATUS
                _infoTile(
                  icon: Icons.check_circle,
                  label: 'Status',
                  value: isActive ? 'Active' : 'Inactive',
                  valueColor:
                      isActive ? Colors.green : Colors.red,
                ),

                const SizedBox(height: 12),

                // 🗺 ROUTES
                _infoTile(
                  icon: Icons.route,
                  label: 'Route Villages',
                  value: routeList.isEmpty
                      ? 'Not specified'
                      : routeList.join(', '),
                ),

                const SizedBox(height: 12),

                // 👤 DRIVER (FUTURE)
                _infoTile(
                  icon: Icons.person,
                  label: 'Assigned Driver',
                  value: 'Not assigned',
                ),

                const SizedBox(height: 12,),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/bus-students',
                        arguments: busId,
                      );
                    },
                    icon: const Icon(Icons.group),
                    label: const Text('View Students'),
                  ),


                const SizedBox(height: 12),

                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/assign-driver',
                        arguments: busId,
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Assign Driver'),
                  ),

              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- CONFIRM DELETE ----------------
  void _confirmDelete(BuildContext context, String busId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Bus'),
        content: const Text(
          'Are you sure you want to delete this bus?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('buses')
                  .doc(busId)
                  .delete();

              if (!context.mounted) return;

              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to list
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ---------------- INFO TILE ----------------
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
