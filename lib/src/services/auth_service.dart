import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // User Registration with Email and Password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print(e); // Handle the error properly
      return null;
    }
  }

  // User Login with Email and Password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e); // Handle the error properly
      return null;
    }
  }

  // User Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // User Login with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e); // Handle the error properly
      return null;
    }
  }

  Future<UserJson> fetchUserData(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    return UserJson.fromJson(
        userDoc.data()!); // Assuming 'User' is your model class
  }

  // Check if User is Logged In
  User? get currentUser => _firebaseAuth.currentUser;

  // Implement additional authentication methods as needed
}
