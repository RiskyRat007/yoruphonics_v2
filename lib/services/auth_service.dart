import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Convert Firebase user → UserModel
  UserModel? _userFromFirebaseUser(User? user, [Map<String, dynamic>? data]) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: data?['name'],
      role: data?['role'] ?? 'pupil',
    );
  }

  // 🔹 Stream of user changes (auth state listener)
  Stream<UserModel?> get user async* {
    await for (final firebaseUser in _auth.authStateChanges()) {
      if (firebaseUser != null) {
        // Fetch Firestore user data for role
        final doc = await _db.collection('users').doc(firebaseUser.uid).get();
        yield _userFromFirebaseUser(firebaseUser, doc.data());
      } else {
        yield null;
      }
    }
  }

  // 🔹 Sign up new user
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      // Create user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user == null) return null;

      // Store user details in Firestore
      await _db.collection('users').doc(user.uid).set({
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Return custom UserModel
      return _userFromFirebaseUser(user, {
        'email': email,
        'name': name,
        'role': role,
      });
    } on FirebaseAuthException catch (e) {
      print("⚠️ Sign up error: ${e.code}");
      rethrow;
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
      if (user == null) return null;

      // Get Firestore data
      final doc = await _db.collection('users').doc(user.uid).get();
      return _userFromFirebaseUser(user, doc.data());
    } on FirebaseAuthException catch (e) {
      print("⚠️ Sign in error: ${e.code}");
      rethrow;
    } catch (e) {
      print("⚠️ General sign in error: $e");
      rethrow;
    }
  }

  // 🔹 Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("⚠️ Sign out error: $e");
    }
  }
}
