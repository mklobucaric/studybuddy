/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Your Cloud Functions
// Importing necessary Firebase functions and admin SDK modules
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(); // Initializes the Firebase admin app

/**
 * Firebase Cloud Function to assign a default role to new users.
 *
 * This function triggers when a new user is created in Firebase Authentication.
 * It assigns a default 'guest' role to the new user by setting a custom claim
 * and updating the 'users' Firestore collection.
 */
exports.addUserRoleOnRegistration = functions.auth.user().onCreate((user) => {
  const usersCollection = admin.firestore().collection('users');

  // Setting the default role in Firestore
  const firestorePromise = usersCollection.doc(user.uid).set({
    role: 'guest',
  }, { merge: true });

  // Setting the default role as a custom user claim
  const claimsPromise = admin.auth().setCustomUserClaims(user.uid, { role: 'guest' });

  // Returning a promise that resolves when both operations are complete
  return Promise.all([firestorePromise, claimsPromise])
    .catch(error => {
      console.error(`Error setting role for user: ${user.uid}`, error);
      // Handle or rethrow the error as necessary
    });
});

/**
 * Firebase Cloud Function to update custom user claims based on Firestore changes.
 *
 * This function listens for updates to any user document in the 'users' Firestore collection.
 * When a user's role is updated in Firestore, this function updates the user's custom claims
 * to reflect the new role.
 */
exports.updateCustomClaimsOnRoleChange = functions.firestore
  .document('users/{userId}')
  .onUpdate((change, context) => {
    const newValue = change.after.data(); // Data after the update
    const oldValue = change.before.data(); // Data before the update

    // Checking if the role has changed
    if (newValue.role !== oldValue.role) {
      // Updating the custom user claims with the new role
      return admin.auth().setCustomUserClaims(context.params.userId, { role: newValue.role });
    } else {
      // No change in role; no action needed
      return null;
    }
  });
