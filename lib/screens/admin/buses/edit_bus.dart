import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBusPage extends StatefulWidget {
  const EditBusPage({super.key});

  @override
  State<EditBusPage> createState() => _EditBusPageState();
}

class _EditBusPageState extends State<EditBusPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController busNumberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController routeController = TextEditingController();

  bool isLoading = true;
  bool isActive = true;

  late String busId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    busId = ModalRoute.of(context)!.settings.arguments as String;
    _loadBusData();
  }

  // ---------------- LOAD BUS DATA ----------------
  Future<void> _loadBusData() async {
    final doc = await FirebaseFirestore.instance
        .collection('buses')
        .doc(busId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    busNumberController.text = data['busNumber'] ?? '';
    capacityController.text = (data['capacity'] ?? '').toString();
    routeController.text =
        (data['routeList'] as List?)?.join(', ') ?? '';
    isActive = data['isActive'] ?? true;

    setState(() => isLoading = false);
  }

  // ---------------- UPDATE BUS ----------------
  Future<void> updateBus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(busId)
          .update({
        'busNumber': busNumberController.text.trim(),
        'capacity': int.parse(capacityController.text.trim()),
        'routeList': routeController.text.trim().isEmpty
            ? []
            : routeController.text
                .split(',')
                .map((e) => e.trim())
                .toList(),
        'isActive': isActive,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bus updated successfully')),
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
        title: const Text('Edit Bus'),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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

                    // 🗺 ROUTES
                    TextFormField(
                      controller: routeController,
                      decoration: const InputDecoration(
                        labelText: 'Route Villages',
                        hintText: 'Village A, Village B',
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

                    // 💾 UPDATE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: updateBus,
                        child: const Text('Update Bus'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
