import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of UserModel? (null if not signed in)
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      // Fetch user role/data from Firestore (check all possible collections)
      try {
        DocumentSnapshot doc = await _firestore
            .collection('students')
            .doc(user.uid)
            .get();
        if (!doc.exists) {
          doc = await _firestore.collection('teachers').doc(user.uid).get();
        }
        if (!doc.exists) {
          doc = await _firestore.collection('researchers').doc(user.uid).get();
        }
        if (!doc.exists) {
          doc = await _firestore.collection('users').doc(user.uid).get();
        }

        if (doc.exists) {
          return UserModel.fromMap(
            doc.data() as Map<String, dynamic>,
            user.uid,
          );
        }
        // If user exists in Auth but not Firestore
        return UserModel(uid: user.uid, email: user.email!, role: 'pupil');
      } catch (e) {
        // Error fetching role
        print("Error fetching user data: $e");
        return null;
      }
    });
  }

  // 🔹 Sign up new user
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    String role, {
    String? gender,
    String? schoolLocation,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Create user doc in Firestore based on role
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          role: role,
          gender: gender,
          schoolLocation: schoolLocation,
        );

        String collection;
        if (role == 'pupil') {
          collection = 'students';
        } else if (role == 'teacher') {
          collection = 'teachers';
        } else if (role == 'researcher') {
          collection = 'researchers';
        } else {
          collection = 'users'; // Fallback
        }

        await _firestore
            .collection(collection)
            .doc(user.uid)
            .set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print("⚠️ General sign up error: $e");
      rethrow;
    }
  }

  // 🔹 Sign in existing user
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
            .collection('students')
            .doc(user.uid)
            .get();
        if (!doc.exists)
          doc = await _firestore.collection('teachers').doc(user.uid).get();
        if (!doc.exists)
          doc = await _firestore.collection('researchers').doc(user.uid).get();
        if (!doc.exists)
          doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromMap(
            doc.data() as Map<String, dynamic>,
            user.uid,
          );
        }
      }
      return null;
    } catch (e) {
      print("⚠️ General sign in error: $e");
      rethrow;
    }
  }

  // 🔹 Sign out user
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  // Pupil "Login" (Anonymous / One-off session)
  Future<UserModel?> signInAnonymously(
    String name,
    String? gender,
    String? schoolLocation,
  ) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: 'anonymous',
          name: name,
          role: 'pupil',
          gender: gender,
          schoolLocation: schoolLocation,
        );
        await _firestore
            .collection('students')
            .doc(user.uid)
            .set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print("Anonymous Auth Failed: $e");
      // Fallback: Create random email/pass if anonymous is disabled
      String randomEmail = '${DateTime.now().microsecondsSinceEpoch}@temp.com';
      return signUpWithEmailAndPassword(
        randomEmail,
        'password123',
        name,
        'pupil',
        gender: gender,
        schoolLocation: schoolLocation,
      );
    }
  }
}
