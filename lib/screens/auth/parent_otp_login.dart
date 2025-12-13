import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_app/services/auth_service.dart';

class ParentOtpLoginPage extends StatefulWidget {
  const ParentOtpLoginPage({super.key});

  @override
  State<ParentOtpLoginPage> createState() => _ParentOtpLoginPageState();
}

class _ParentOtpLoginPageState extends State<ParentOtpLoginPage> {

  // Controllers for user input
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // Firebase verification id (received after OTP is sent)
  String verificationId = '';

  // UI state variables
  bool otpSent = false;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
    ---------------- SEND OTP ----------------

    1. Takes phone number
    2. Firebase sends OTP
    3. Stores verificationId
    4. Shows OTP field
  */
  Future<void> sendOtp() async {
    setState(() => loading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text.trim()}",
      timeout: const Duration(seconds: 60),

      // Automatic verification (rare, Android only)
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      // OTP sending failed
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "OTP failed")),
        );
        setState(() => loading = false);
      },

      // OTP sent successfully
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        otpSent = true;
        loading = false;
        setState(() {});
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  /*
    ---------------- VERIFY OTP ----------------

    Flow:
    OTP → Firebase Auth → uid
         ↓
    Check Firestore users/{uid}
         ↓
    First time → Language selection
    Existing parent → Parent home
    Wrong role → Logout
  */
  Future<void> verifyOtp() async {
    setState(() => loading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );

      final userCredential =
          await _auth.signInWithCredential(credential);

      final uid = userCredential.user!.uid;

      final authService = AuthService();

      // Check if Firestore document exists
      final exists = await authService.userExists(uid);

      if (!exists) {
        // First-time parent
        Navigator.pushReplacementNamed(context, '/language-selection');
        return;
      }

      // Check role
      final role = await authService.getUserRole(uid);

      if (role != 'parent') {
        // Security block
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Access denied")),
        );
        return;
      }

      // Valid parent
      Navigator.pushReplacementNamed(context, '/parent-home');

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Invalid OTP")),
      );
    }
    finally{
          setState(() => loading = false);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Phone number input
            if (!otpSent)
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "10 digit mobile number",
                  prefixText: "+91 ",
                  border: OutlineInputBorder(),
                ),
              ),

            // OTP input
            if (otpSent)
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20),

            // Send / Verify button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : otpSent
                        ? verifyOtp
                        : sendOtp,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(otpSent ? "Verify OTP" : "Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
