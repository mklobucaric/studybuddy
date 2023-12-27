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
  Future<User?> registerWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // Prompt user to sign in with Google
      // This can be a UI prompt/option
      await Future.delayed(const Duration(seconds: 1));

      // Check if the context is still valid
      if (!context.mounted) return null;
      bool shouldLinkGoogle =
          await promptUserForGoogleLink(context); // Implement this

      if (shouldLinkGoogle) {
        // Start Google sign-in process
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Link Google account
        try {
          await user?.linkWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          // Handle different error scenarios
          // For example, show an error message to the user
          await Future.delayed(const Duration(seconds: 1));

          // Check if the context is still valid
          if (!context.mounted) return null;
          handleLinkingError(context, e); // Implement this
        }
      }

      return user;
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
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user; // Return the user after linking
    }

    // UserCredential userCredential =
    //     await _firebaseAuth.signInWithCredential(credential);
    // return userCredential.user;
    catch (e) {
      print(e); // Handle the error properly
      return null;
    }
  }

  Future<UserJson?> fetchUserData(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return UserJson.fromJson(
          userDoc.data()!); // Assuming 'UserJson' is your model class
    } else {
      // User document does not exist
      return null; // or throw a custom exception if you prefer
    }
  }

  // Future<UserJson> fetchUserData(String userId) async {
  //   var userDoc = await _firestore.collection('users').doc(userId).get();
  //   return UserJson.fromJson(
  //       userDoc.data()!); // Assuming 'UserJson' is your model class
  // }

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

  // Check user permissions and return the ID token if they are an admin or subscriber
  Future<String?> checkUserPermissions() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print("User is null");
      return null;
    }

    IdTokenResult tokenResult = await user.getIdTokenResult(true);
    Map<String, dynamic>? claims = tokenResult.claims;

    if (claims != null &&
        (claims['admin'] == true || claims['subscriber'] == true)) {
      return tokenResult
          .token; // Return the token if the user is an admin or a subscriber
    } else {
      print("User does not have the required role");
      return null;
    }
  }

  void handleLinkingError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case "provider-already-linked":
        errorMessage = "This provider is already linked to your account.";
        break;
      case "invalid-credential":
        errorMessage = "The provided credential is invalid.";
        break;
      case "credential-already-in-use":
        errorMessage = "An account already exists with the same credential.";
        break;
      default:
        errorMessage = "An unknown error occurred.";
        print(e.toString()); // Optionally log the error for debugging
    }

    // Display the error message
    // Here, we are using a simple dialog, but you can use any method you prefer
    showDialog(
      context: context, // Ensure you have a BuildContext available
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Linking Account'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> checkPermissionsAndGetToken(User user) async {
    IdTokenResult tokenResult = await user.getIdTokenResult(true);
    Map<String, dynamic>? claims = tokenResult.claims;

    if (claims != null &&
        (claims['role'] == 'admin' || claims['role'] == 'subscriber')) {
      return tokenResult
          .token; // Return the token if the user has the required role
    } else {
      print("User does not have the required role");
      return null;
    }
  }

  // Check if User is Logged In
  User? get currentUser => _firebaseAuth.currentUser;

  // Implement additional authentication methods as needed
}
