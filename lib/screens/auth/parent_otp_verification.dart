import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_app/app/routes/app_routes.dart';

class ParentOtpVerificationPage extends StatefulWidget {
  const ParentOtpVerificationPage({
    super.key,
    required this.phoneNumber, required String verificationId,
  });

  final String phoneNumber; // +91XXXXXXXXXX

  @override
  State<ParentOtpVerificationPage> createState() =>
      _ParentOtpVerificationPageState();
}

class _ParentOtpVerificationPageState
    extends State<ParentOtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  String verificationId = '';

  Future<void> onVerifyOtpPressed(
  String verificationId,
  String otp,
) async {
  setState(() => loading = true);

  try {
    // 1️⃣ Create phone auth credential
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    // 2️⃣ Sign in with credential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Authentication failed');
    }

    final uid = user.uid;
    final verifiedPhone = user.phoneNumber; // +91XXXXXXXXXX

    // 3️⃣ Check if user already exists
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      // ✅ Returning parent
      Navigator.pushReplacementNamed(context, AppRoutes.parentHome);
      return;
    }

    // 4️⃣ First time parent → find student by phone
    final studentQuery = await FirebaseFirestore.instance
        .collection('students')
        .where('parentPhone', isEqualTo: verifiedPhone)
        .limit(1)
        .get();

    if (studentQuery.docs.isEmpty) {
      // ❌ Phone not registered
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your number is not registered with the bus service'),
        ),
      );
      return;
    }

    final studentId = studentQuery.docs.first.id;

    // 5️⃣ Create users collection entry
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'role': 'parent',
      'phone': verifiedPhone,
      'studentId': studentId,
      'language': 'en',
      'createdAt': Timestamp.now(),
    });

    // 6️⃣ Navigate to Parent Home
    Navigator.pushReplacementNamed(context, AppRoutes.parentHome);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'OTP verification failed')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => loading = false);
  }
}


  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              const Text(
                'Enter the OTP sent to',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 4),

              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // ---------------- OTP INPUT ----------------
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: '6-digit OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Enter valid 6 digit OTP';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ---------------- VERIFY BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () => onVerifyOtpPressed(verificationId, otpController.text),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('VERIFY OTP'),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------- RESEND OTP ----------------
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OTP resent (UI only)'),
                          ),
                        );
                      },
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
