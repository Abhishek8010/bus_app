import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -----------------------------
  // ADMIN LOGIN FUNCTION
  // -----------------------------
  Future<User?> loginAdmin(String email, String password) async {
    // 1. Login using email + password
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    User? user = result.user;

    if (user == null) {
      throw Exception("Login failed");
    }

    // 2. Check firestore role
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      throw Exception("User not found in database");
    }

    // 3. Confirm role = admin
    if (doc['role'] != 'admin') {
      throw Exception("Unauthorized! This account is not admin.");
    }
    print("Logged in UID: ${user.uid}");


    // 4. Return user if everything is good
    return user;
  }
}
