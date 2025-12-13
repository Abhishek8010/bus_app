import 'package:bus_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/screens/auth/admin_login.dart';
import 'parent_otp_login.dart';

class LoginSelectionPage extends StatefulWidget {
  const LoginSelectionPage({super.key});

  @override
  State<LoginSelectionPage> createState() => _LoginSelectionPageState();
}

class _LoginSelectionPageState extends State<LoginSelectionPage> {
  int _tapCount = 0;

  void _handleLogoTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount == 5) {
      _tapCount = 0; // reset after unlock
      Navigator.push(
        context,
        MaterialPageRoute( builder: (_) => const AdminLoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------- Logo + Secret Admin Unlock ----------
              GestureDetector(
                onTap: _handleLogoTap,
                child: Column(
                  children: [
                  ClipOval(
                      child: Image.asset(
                        'assets/images/schoolbus.jpg',
                        height: 120,
                        width: 120, // Setting width equal to height ensures a perfect circle
                        fit: BoxFit.contain, // Ensures the image covers the entire circle area
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tap logo 5 times for Admin Login",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Select Login Type",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // ---------- Parent Login Button ----------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ParentOtpLoginPage()),
                    );
                  },
                  child: const Text("Parent Login (OTP)"),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- Parent Signup (Optional) ----------
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // You can add logic later — not needed now
                  },
                  child: const Text("Parent Sign-Up"),
                ),
              ),

              const SizedBox(height: 40),

              // ---------- Language Selection ----------
              IconButton(
                icon: const Icon(Icons.language, size: 30),
                onPressed: () {
                  // Open language selection screen here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
