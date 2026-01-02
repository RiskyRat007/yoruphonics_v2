import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of UserModel? (null if not signed in)
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      // Fetch user role/data from Firestore
      try {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return UserModel.fromMap(
            doc.data() as Map<String, dynamic>,
            user.uid,
          );
        }
        // If user exists in Auth but not Firestore (rare edge case), return basic user with default role?
        // Or better, return null or handle appropriately. For now, let's treat as 'pupil'.
        return UserModel(uid: user.uid, email: user.email!, role: 'pupil');
      } catch (e) {
        // Error fetching role
        print("Error fetching user data: $e");
        return null;
      }
    });
  }

  // Sign Up
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Create user doc in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          role: role,
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Sign In
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return UserModel.fromMap(
            doc.data() as Map<String, dynamic>,
            user.uid,
          );
        }
      }
      return null;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
