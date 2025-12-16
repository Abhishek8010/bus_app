import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_app/services/auth_service.dart';
import 'package:bus_app/services/firestore_service.dart';
import 'package:bus_app/app/routes/app_routes.dart';
import 'package:bus_app/screens/auth/parent_otp_verification.dart';

class ParentOtpLoginPage extends StatefulWidget {
  const ParentOtpLoginPage({super.key});

  @override
  State<ParentOtpLoginPage> createState() => _ParentOtpLoginPageState();
}

class _ParentOtpLoginPageState extends State<ParentOtpLoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  // -------- TEMPORARY ACTION (NO LOGIC YET) --------
  Future<void> sendOtp(BuildContext context, String phoneNumber) async {
  setState(() => loading = true);

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+91$phoneNumber',
    timeout: const Duration(seconds: 60),

    // 🔹 ANDROID: Auto verification
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },

    // 🔹 Error
    verificationFailed: (FirebaseAuthException e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'OTP failed')),
      );
    },

    // 🔹 OTP sent
    codeSent: (String verificationId, int? resendToken) {
      setState(() => loading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ParentOtpVerificationPage(
            phoneNumber: '+91$phoneNumber',
            verificationId: verificationId,
          ),
        ),
      );
    },

    // 🔹 Timeout
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}


  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Login'),
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
                Icons.phone_android,
                size: 80,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              const Text(
                'Enter your registered mobile number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 32),

              // ---------------- PHONE INPUT ----------------
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+91 ',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().length != 10) {
                    return 'Enter valid 10 digit number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ---------------- SEND OTP BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : () => sendOtp(context, phoneController.text),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SEND OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
