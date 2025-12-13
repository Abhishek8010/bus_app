import 'package:flutter/material.dart';
import 'package:bus_app/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_app/services/auth_service.dart';
import 'package:bus_app/screens/admin/dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;                                   //Initially the loading variable set to false. i.e. no loading is happening

  void loginAdmin() async {
    setState(() => loading = true);                        // loginAdmin function is called when we click on login button(written below). it states the loading true 

    try {
       final email = emailController.text;
       final password = passwordController.text;

       final user = await AuthService().loginAdmin(email, password);

       // LOGIN SUCCESS → GO TO ADMIN DASHBOARD
       Navigator.pushReplacement(context,  MaterialPageRoute(
                          builder: (_) => const AdminDashboard()),);
          

       // After login, check if admin
       // Later you will check Firestore role = "admin"

       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Admin login successful")),
       );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    //this block will execute compulsorily. therefore after we get value of user through future, we state loading = false
    finally{
    setState(() => loading = false);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Admin Email",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 30),

            // loading
            loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loginAdmin,
                      child: const Text("Login"),
                    ),
                  ),

          ],
          
        ),
      ),
    );
  }
}
