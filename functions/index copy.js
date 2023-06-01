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
    const plante = change.after.data();
    console.log("plante", plante);
    functions.firestore
      .document("users/{userId}")
      .onWrite((change, context) => {
        const userDeviceToken = change.after.data().token;
        console.log("userDeviceToken", userDeviceToken);
        return change.after.ref.set(
          { token: userDeviceToken },
          { merge: true }
        );
      });
    const message = {
      data: {
        title: "Nouvelle plante",
        body: plante.name,
      },
      token: userDeviceToken,
    };
    if (plante) {
      const payload = {
        notification: {
          title: "Nouvelle plante",
          body: "Une nouvelle plante a été ajouté",
        },
      };
      return getMessaging()
        .send(message)
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    }
  });

// export const getUsersTokenDevice = onDocumentCreated(
//   "/users/{userId}",
//   (event) => {
//     const userDeviceToken = event.data.data().token;
//     logger.log("userDeviceToken", userDeviceToken);
//     return event.data.ref.set({ token: userDeviceToken }, { merge: true });
//   }
// );
