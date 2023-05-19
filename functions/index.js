/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.getUserPlants = functions.https.onRequest((req, res) => {
  let userPlantsCron = [];
  let db = admin.firestore();
  db.collection("userPlante")
    .get()
    .then((snapshot) => {
      snapshot.forEach((doc) => {
        userPlantsCron.push(doc.data());
      });
      res.send(userPlantsCron);
      console.log("userPlantsCron", userPlantsCron);
    })
    .catch((err) => {
      res.send(err);
    });
});

exports.cronJob = functions
  .region("us-central1")
  .pubsub.schedule("5 12 * * *")
  .timeZone("Europe/Paris")
  .onRun(() => {
    console.log("This will be run every 5 minutes at 12 to get userPlants!");
    getUserPlants();
    return null;
  });
