import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Checks if phone number exists AND role == parent
  Future<Map<String, dynamic>?> getParentUserByPhone(String phone) async {
    final query = await _db
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first.data();
  }
















  /// Add student + link/create parent user
  Future<void> addStudentWithParent({
    required String studentName,
    required String parentName,
    required String parentPhone,
    required String busId,
  }) async {

    // 🔹 STEP 1: Create student
    final studentRef = await _db.collection('students').add({
      'name': studentName,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'busId': busId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final String studentId = studentRef.id;

    // 🔹 STEP 2: Check if parent already exists
    final parentQuery = await _db
        .collection('users')
        .where('phone', isEqualTo: parentPhone)
        .limit(1)
        .get();

    // 🔹 STEP 3: If parent exists → update studentIds
    if (parentQuery.docs.isNotEmpty) {
      final parentDoc = parentQuery.docs.first.reference;

      await parentDoc.update({
        'studentIds': FieldValue.arrayUnion([studentId]),
      });

    } else {
      // 🔹 STEP 4: If parent does not exist → create new parent user
      await _db.collection('users').add({
        'phone': parentPhone,
        'role': 'parent',
        'studentIds': [studentId],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
