import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';




class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
    final FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(
      app: Firebase.app(),
);


    String? selectedBusId;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController villageController = TextEditingController();


  final TextEditingController parentEmailController = TextEditingController();


  bool loading = false;

// ---------------- SAVE STUDENT ----------------
  Future<void> saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final phone = parentPhoneController.text.trim();
      final parentEmail = parentEmailController.text.trim();

      // 1️⃣ CREATE STUDENT FIRST (CAPTURE ID)
      final studentRef =
          await FirebaseFirestore.instance.collection('students').add({
        'name': studentNameController.text.trim(),
        'parentName': parentNameController.text.trim(),
        'parentPhone': '+91$phone',
        'parentEmail': parentEmail,
        'village': villageController.text.trim(),
        'busId': selectedBusId,
        'isActive': true,
        'createdAt': Timestamp.now(),
      });

      final String studentId = studentRef.id; // ✅ VERY IMPORTANT

      // 2️⃣ ENSURE PARENT EXISTS IN FIREBASE AUTH
      UserCredential? credential;

      try {
      credential = await secondaryAuth
          .createUserWithEmailAndPassword(
          email: parentEmail,
          password: 'Temp@123',
        );

      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Parent already exists → fetch current user
          credential = null;
        } else {
          rethrow;
        }
      }

      // 3️⃣ GET PARENT UID (FROM AUTH OR FIRESTORE)
      String parentUid;

      if (credential != null) {
        // New parent created
        parentUid = credential.user!.uid;

        // Create users document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(parentUid)
            .set({
          'email': parentEmail,
          'role': 'parent',
          'studentIds': [studentId],
          'createdAt': Timestamp.now(),
        });
      } else {
        // Parent already exists → find Firestore user
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: parentEmail)
            .where('role', isEqualTo: 'parent')
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          throw Exception('Parent user record not found');
        }

        parentUid = query.docs.first.id;

        // 4️⃣ APPEND STUDENT ID (CRITICAL FIX)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(parentUid)
            .update({
          'studentIds': FieldValue.arrayUnion([studentId]),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Student added successfully.\nParent should use "Forgot Password" to set password.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }
    


  @override
  void dispose() {
    studentNameController.dispose();
    parentNameController.dispose();
    parentPhoneController.dispose();
    parentEmailController.dispose();
    villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              _buildInput(
                controller: studentNameController,
                label: 'Student Name',
                icon: Icons.person,
              ),

              _buildInput(
                controller: parentNameController,
                label: 'Parent Name',
                icon: Icons.person_outline,
              ),

              _buildPhoneInput(),
              _buildEmailInput(),

              _buildInput(
                controller: villageController,
                label: 'Village',
                icon: Icons.location_on,
              ),

              // _buildInput(
              //   controller: busIdController,
              //   label: 'Bus ID / Number',
              //   icon: Icons.directions_bus,
              // ),
              _buildBusDropdown(),


              

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : saveStudent,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SAVE STUDENT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  // ---------------- INPUT FIELD ----------------
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  // ---------------- PHONE INPUT ----------------
  Widget _buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: parentPhoneController,
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
          labelText: 'Parent Phone',
          prefixText: '+91 ',
          prefixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          counterText: '',
        ),
        validator: (value) {
          if (value == null || value.length != 10) {
            return 'Enter valid 10 digit number';
          }
          return null;
        },
      ),
    );
  }


  // ---------------- EMAIL INPUT ----------------
  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: parentEmailController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Parent Email',
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          counterText: '',
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter Email Address';
          }
          return null;
        },
      ),
    );
  }
  
  // ---------------- BUS DROPDOWN ----------------
  Widget _buildBusDropdown() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('buses')
          .where('isActive', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final buses = snapshot.data!.docs;

        if (buses.isEmpty) {
          return const Text('No active buses available');
        }

        return DropdownButtonFormField<String>(
          value: selectedBusId,
          decoration: InputDecoration(
            labelText: 'Assign Bus',
            prefixIcon: const Icon(Icons.directions_bus),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: buses.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DropdownMenuItem(
              value: doc.id, // 🔥 Firestore busId
              child: Text(data['busNumber']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedBusId = value);
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a bus';
            }
            return null;
          },
        );
      },
    ),
  );
}

}
