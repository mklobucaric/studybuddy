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
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.addUserRoleOnRegistration = functions.auth.user().onCreate((user) => {
  const usersCollection = admin.firestore().collection('users');

  const firestorePromise = usersCollection.doc(user.uid).set({
    role: 'guest',
  }, { merge: true });

  const claimsPromise = admin.auth().setCustomUserClaims(user.uid, { role: 'guest' });

  return Promise.all([firestorePromise, claimsPromise])
    .catch(error => {
      console.error(`Error setting role for user: ${user.uid}`, error);
      // Handle or rethrow the error as necessary
    });
});





exports.updateCustomClaimsOnRoleChange = functions.firestore
  .document('users/{userId}')
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const oldValue = change.before.data();

    if (newValue.role !== oldValue.role) {
      return admin.auth().setCustomUserClaims(context.params.userId, { role: newValue.role });
    } else {
      return null;
    }
  });
