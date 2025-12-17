import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_app/services/auth_service.dart';
import 'package:bus_app/services/firestore_service.dart';
import 'package:bus_app/app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentEmailLoginPage extends StatefulWidget {
  const ParentEmailLoginPage({super.key});

  @override
  State<ParentEmailLoginPage> createState() => _ParentEmailLoginPageState();
}

class _ParentEmailLoginPageState extends State<ParentEmailLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;


    Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password setup link sent to your email.\nPlease check inbox or spam.",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'user-not-found') {
        message = "No parent registered with this email";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
 

  
Future<void> loginParent() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter email and password")),
    );
    return;
  }

  try {
    setState(() => isLoading = true);

    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final user = credential.user;

    if (user == null) {
      throw Exception("Login failed");
    }

    // 🔥 THIS WAS MISSING
    await handleParentAfterLogin(user);

  } on FirebaseAuthException catch (e) {
    String message = "Login failed";

    if (e.code == 'user-not-found') {
      message = "No account found. Use 'Forgot Password' first.";
    } else if (e.code == 'wrong-password') {
      message = "Incorrect password";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => isLoading = false);
  }
}



Future<void> handleParentAfterLogin(User user) async {
  final firestore = FirebaseFirestore.instance;

  final uid = user.uid;
  final email = user.email;

  if (email == null) {
    throw Exception("Email not found for this user");
  }

  final userDocRef = firestore.collection('users').doc(uid);
  final userDoc = await userDocRef.get();

  // 🔹 STEP A: If users/{uid} does NOT exist → create it
  if (!userDoc.exists) {
    // Find students linked to this parent email
    final studentQuery = await firestore
        .collection('students')
        .where('parentEmail', isEqualTo: email)
        .get();

    if (studentQuery.docs.isEmpty) {
      throw Exception("No students linked to this parent email");
    }

    // Collect student IDs
    final studentIds = studentQuery.docs.map((doc) => doc.id).toList();

    // Create users document. As soon as we create login, we create user record in firestore for that parent
    await userDocRef.set({
      'name': studentQuery.docs.first['parentName'],
      'email': email,
      'role': 'parent',
      'studentIds': studentIds,
      'language': 'en',
      'createdAt': Timestamp.now(),
    });

    // OPTIONAL (but recommended): attach parentUserId to students
    for (var doc in studentQuery.docs) {
      await firestore.collection('students').doc(doc.id).update({
        'parentUserId': uid,
      });
    }
  }

  // 🔹 STEP B: Navigate to Parent Home
  if (!mounted) return;

  Navigator.pushReplacementNamed(context, '/parent-home');
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 40),

            // App Logo / Icon
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.directions_bus,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Heading
            const Text(
              "Welcome Parent",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Login using your registered email",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Email Field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "parent@email.com",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(

                onPressed: 
                  isLoading ? null : sendPasswordResetEmail,
                
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        loginParent();
                      },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Info Text
            const Text(
              "First time login?\nUse 'Forgot Password' to set your password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
