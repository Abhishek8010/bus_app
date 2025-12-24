// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AssignDriverPage extends StatefulWidget {
//   const AssignDriverPage({super.key});

//   @override
//   State<AssignDriverPage> createState() => _AssignDriverPageState();
// }

// class _AssignDriverPageState extends State<AssignDriverPage> {
//   String? selectedDriverId;
//   bool isSaving = false;

//   late String busId;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     busId = ModalRoute.of(context)!.settings.arguments as String;
//     _loadCurrentAssignment();
//   }

//   // -------- LOAD CURRENT DRIVER ASSIGNMENT --------
//   Future<void> _loadCurrentAssignment() async {
//     final busDoc = await FirebaseFirestore.instance
//         .collection('buses')
//         .doc(busId)
//         .get();

//     if (busDoc.exists) {
//       setState(() {
//         selectedDriverId = busDoc.data()?['driverId'];
//       });
//     }
//   }

//   // -------- SAVE ASSIGNMENT --------
//   Future<void> _saveAssignment() async {
//     if (selectedDriverId == null) return;

//     setState(() => isSaving = true);

//     final firestore = FirebaseFirestore.instance;

//     try {
//       // 1️⃣ Remove previous driver (if any)
//       final busDoc = await firestore.collection('buses').doc(busId).get();
//       final oldDriverId = busDoc.data()?['driverId'];

//       if (oldDriverId != null) {
//         await firestore
//             .collection('drivers')
//             .doc(oldDriverId)
//             .update({'assignedBusId': null});
//       }

//       // 2️⃣ Assign new driver
//       await firestore.collection('buses').doc(busId).update({
//         'driverId': selectedDriverId,
//       });

//       await firestore.collection('drivers').doc(selectedDriverId).update({
//         'assignedBusId': busId,
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Driver assigned successfully')),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Assign Driver'),
//       ),

//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('drivers')
//             .where('assignedBusId', isEqualTo: null)
//             .snapshots(),

//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No available drivers'),
//             );
//           }

//           final drivers = snapshot.data!.docs;

//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               const Text(
//                 'Select a driver for this bus',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               ...drivers.map((doc) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final driverId = doc.id;

//                 return RadioListTile<String>(
//                   value: driverId,
//                   groupValue: selectedDriverId,
//                   title: Text(data['name'] ?? 'Unnamed'),
//                   subtitle: Text(data['phone'] ?? ''),
//                   onChanged: (value) {
//                     setState(() => selectedDriverId = value);
//                   },
//                 );
//               }).toList(),

//               const SizedBox(height: 30),

//               SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: isSaving ? null : _saveAssignment,
//                   child: isSaving
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Save Assignment'),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
