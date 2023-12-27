import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/user.dart';
import 'package:studybuddy/src/utils/dialog_utils.dart';

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
    } on FirebaseAuthException {
      rethrow;
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
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //final email = googleUser.email;

      try {
        // Attempt to sign in with Google credential
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return userCredential.user; // Return the user if successful
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // The account already exists with a different credential
          String email = e.email!;

          await Future.delayed(const Duration(seconds: 1));

          // Check if the context is still valid
          if (!context.mounted) return null;
          // Prompt user to enter their password
          String? password = await promptForPassword(context);

          try {
            if (password != null && password.isNotEmpty) {
              // Sign the user in to their account with the password
              UserCredential userCredential = await _firebaseAuth
                  .signInWithEmailAndPassword(email: email, password: password);

              // Link the pending credential with the existing account
              await userCredential.user!.linkWithCredential(credential);
              return userCredential.user; // Return the user after linking
            }
          } catch (e) {
            print(e); // Handle errors during account linking
            return null;
          }
        } else {
          // Handle other FirebaseAuthExceptions
          print(e);
          return null;
        }
      }
    }

    // UserCredential userCredential =
    //     await _firebaseAuth.signInWithCredential(credential);
    // return userCredential.user;
    catch (e) {
      print(e); // Handle the error properly
      return null;
    }
    return null;
  }

  Future<UserJson> fetchUserData(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    return UserJson.fromJson(
        userDoc.data()!); // Assuming 'UserJson' is your model class
  }

// Function to check and store user data in Firestore
  Future<void> checkAndStoreUserData(User user) async {
    final usersCollection = _firestore.collection('users');

    final userDoc = await usersCollection.doc(user.uid).get();
    print(userDoc.id);

    if (!userDoc.exists) {
      // If user data doesn't exist, store it in Firestore
      await usersCollection.doc(user.uid).set({
        'id': user.uid,
        'firstName': user.displayName
            ?.split(' ')
            .first, // Assuming first part is the first name
        'lastName': user.displayName
            ?.split(' ')
            .last, // Assuming second part is the last name
        'email': user.email,
      });
    }
  }

  void checkUserPermissions() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      Map<String, dynamic>? claims = tokenResult.claims;

      if (claims != null) {
        // Check for specific claims
        if (claims['admin'] == true) {
          // Grant admin permissions
        }
      } else {
        print("Claims are null");
      }
    } else {
      print("User is null");
    }
  }

  // Check if User is Logged In
  User? get currentUser => _firebaseAuth.currentUser;

  // Implement additional authentication methods as needed
}
