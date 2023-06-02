/**
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { getMessaging } = require("firebase-admin/messaging");
admin.initializeApp(functions.config().firebase);

exports.notification = functions.firestore
  .document("userPlante/{docId}")
  .onWrite((change, context) => {
    const value = change.after.data();
    console.log("value", value);
    if (value) {
      const data = {
        notification: {
          title: "Nouvelle plante",
          body: "PLANTE",
        },
      };
      return admin
        .messaging()
        .sendToTopic("messaging", data)
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    }
  });

// exports.notification2 = functions.firestore
//   .document("userPlante/{docId}")
//   .onWrite((change, context) => {
//     const topic = "messaging";
//     const value = change.after.data();
//     const oldValue = change.before.data();
//     const message = {
//       data: {
//         title: "Messaging Topic",
//         body: "This is a Firebase Cloud Messaging Topic Message!",
//       },
//       topic: topic,
//     };
//     getMessaging().send(message);
//   });
