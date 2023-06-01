/**
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.notification = functions.firestore
  .document("userPlante/{docId}")
  .onWrite((change, context) => {
    const value = change.after.data();
    console.log("value", value);
    if (value) {
      const payload = {
        notification: {
          title: "Nouvelle plante",
          body: "Une nouvelle plante a été ajouté",
        },
      };
      return admin
        .messaging()
        .sendToTopic("messaging", payload)
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    }
  });
