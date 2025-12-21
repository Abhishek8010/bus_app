import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController busNumberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController routeController = TextEditingController();

  bool isLoading = false;
  bool isActive = true;

  // ---------------- SAVE BUS ----------------
  Future<void> saveBus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('buses').add({
        'busNumber': busNumberController.text.trim(),
        'capacity': int.parse(capacityController.text.trim()),
        'routeList': routeController.text.trim().isEmpty
            ? []
            : routeController.text
                .split(',')
                .map((e) => e.trim())
                .toList(),
        'driverId': null,
        'isActive': isActive,
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bus added successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    busNumberController.dispose();
    capacityController.dispose();
    routeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bus'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🚌 BUS NUMBER
              TextFormField(
                controller: busNumberController,
                decoration: const InputDecoration(
                  labelText: 'Bus Number',
                  hintText: 'MH20 AB 1234',
                  prefixIcon: Icon(Icons.directions_bus),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bus number is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 👥 CAPACITY
              TextFormField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  hintText: '40',
                  prefixIcon: Icon(Icons.people),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Capacity is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 🗺 ROUTE (OPTIONAL)
              TextFormField(
                controller: routeController,
                decoration: const InputDecoration(
                  labelText: 'Route Villages (Optional)',
                  hintText: 'Village A, Village B, Village C',
                  prefixIcon: Icon(Icons.route),
                ),
              ),

              const SizedBox(height: 16),

              // ✅ ACTIVE SWITCH
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Bus Active'),
                value: isActive,
                onChanged: (value) {
                  setState(() => isActive = value);
                },
              ),

              const SizedBox(height: 30),

              // 💾 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveBus,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Save Bus'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
