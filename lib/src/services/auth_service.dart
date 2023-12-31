import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/user.dart';
import 'package:studybuddy/src/utils/dialog_utils.dart';

class AuthService {
  // Firebase Authentication instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Firestore instance for database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if User is Logged In
  User? get currentUser => _firebaseAuth.currentUser;

  /// Registers a user with email and password, and optionally links a Google account.
  ///
  /// [context] is used for UI interaction like prompting for Google link.
  /// [email] and [password] are credentials for registration.
  ///
  /// Returns the newly created `User` object or `null` on failure.
  Future<User?> registerWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // Delay for UI prompt simulation
      await Future.delayed(const Duration(seconds: 1));

      // Context validation check
      if (!context.mounted) return null;

      // Prompt for linking with Google account
      bool shouldLinkGoogle =
          await promptUserForGoogleLink(context); // Needs implementation

      if (shouldLinkGoogle) {
        // Google Sign-In process
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
          // Error handling for account linking
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return null;
          handleLinkingError(context, e); // Needs implementation
        }
      }

      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e); // Proper error handling should be implemented
      }

      return null;
    }
  }

  /// Logs in a user using email and password.
  ///
  /// [email] and [password] are credentials for login.
  ///
  /// Returns the `User` object on successful login, or `null` on failure.
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e); // Proper error handling should be implemented
      }

      return null;
    }
  }

  /// Logs out the currently signed-in user.
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Signs in a user using Google authentication.
  ///
  /// [context] is used for potential UI interactions during the process.
  ///
  /// Returns the `User` object on successful login, or `null` on failure.
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
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e); // Proper error handling should be implemented
      }

      return null;
    }
  }

  /// Fetches user data from Firestore based on the provided user ID.
  ///
  /// [userId] is the identifier of the user.
  ///
  /// Returns a `UserJson` object on success, or `null` if the user doesn't exist.
  Future<UserJson?> fetchUserData(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return UserJson.fromJson(
          userDoc.data()!); // 'UserJson' needs to be defined
    } else {
      return null; // Handle non-existence of user data appropriately
    }
  }

  /// Checks and stores user data in Firestore.
  ///
  /// [user] is the `User` object containing the user's information.
  ///
  /// Ensures user data is stored in Firestore if it doesn't already exist.
  Future<void> checkAndStoreUserData(User user) async {
    final usersCollection = _firestore.collection('users');

    final userDoc = await usersCollection.doc(user.uid).get();

    if (!userDoc.exists) {
      // Storing user data in Firestore
      await usersCollection.doc(user.uid).set({
        'id': user.uid,
        'firstName': user.displayName
            ?.split(' ')
            .first, // Assumes first part is the first name
        'lastName': user.displayName
            ?.split(' ')
            .last, // Assumes second part is the last name
        'email': user.email,
      });
    }
  }

  /// Checks user permissions and returns their ID token if they are an admin or subscriber.
  ///
  /// Returns the ID token for users with 'admin' or 'subscriber' roles, or `null` otherwise.
  Future<String?> checkPermissionsAndGetToken(User user) async {
    IdTokenResult tokenResult = await user.getIdTokenResult(true);
    Map<String, dynamic>? claims = tokenResult.claims;

    if (claims != null &&
        (claims['role'] == 'admin' || claims['role'] == 'subscriber')) {
      return tokenResult
          .token; // Return the token if the user has the required role
    } else {
      if (kDebugMode) {
        print("User does not have the required role");
      }

      return null;
    }
  }

  /// Handles errors that occur during account linking.
  ///
  /// [context] is the BuildContext for UI interactions.
  /// [e] is the FirebaseAuthException that occurred.
  ///
  /// Displays an error message based on the exception code.
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
        if (kDebugMode) {
          print(e.toString()); // Optional error logging
        }
    }

    // UI to display the error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Linking Account'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Additional methods and comments can be added here.
}
