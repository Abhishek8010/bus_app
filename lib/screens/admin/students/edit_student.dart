import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EditStudentPage extends StatefulWidget {
  const EditStudentPage({super.key});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController busIdController = TextEditingController();

  bool loading = false;
  bool isActive = true;

  late String studentId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    studentId = ModalRoute.of(context)!.settings.arguments as String;
    _loadStudentData();
  }

  // ---------------- LOAD STUDENT ----------------
  Future<void> _loadStudentData() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    studentNameController.text = data['name'] ?? '';
    parentNameController.text = data['parentName'] ?? '';
    parentPhoneController.text =
        (data['parentPhone'] ?? '').toString().replaceFirst('+91', '');
    villageController.text = data['village'] ?? '';
    busIdController.text = data['busId'] ?? '';
    isActive = data['isActive'] ?? true;

    setState(() {});
  }

  // ---------------- UPDATE STUDENT ----------------
  Future<void> updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .update({
        'name': studentNameController.text.trim(),
        'parentName': parentNameController.text.trim(),
        'parentPhone': '+91${parentPhoneController.text.trim()}',
        'village': villageController.text.trim(),
        'busId': busIdController.text.trim(),
        'isActive': isActive,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully')),
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
    villageController.dispose();
    busIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              _inputField(
                controller: studentNameController,
                label: 'Student Name',
                icon: Icons.person,
              ),

              _inputField(
                controller: parentNameController,
                label: 'Parent Name',
                icon: Icons.person_outline,
              ),

              _phoneField(),

              _inputField(
                controller: villageController,
                label: 'Village',
                icon: Icons.location_on,
              ),

              _inputField(
                controller: busIdController,
                label: 'Bus ID / Number',
                icon: Icons.directions_bus,
              ),

              SwitchListTile(
                title: const Text('Active Student'),
                value: isActive,
                onChanged: (value) {
                  setState(() => isActive = value);
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : updateStudent,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('UPDATE STUDENT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- INPUT ----------------
  Widget _inputField({
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

  // ---------------- PHONE ----------------
  Widget _phoneField() {
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
}
