var functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendOrderNotification = functions.firestore
  .document("orders/{orderId}")
  .onWrite((snap) => {
    console.log(
      "----------------Start Order Notification Function--------------------"
    );

    const stAfter = snap.after.data()["status"];
    const stBefor = snap.before.data()["status"];
    const uId = snap.after.data()["user"]["mail"];

    console.log("stAfter: " + stAfter);
    console.log("stBefor: " + stBefor);
    console.log("uId: " + uId);

    const snapshot = admin.firestore().collection("UserActivity").doc(uId);
    snapshot.get().then((doc) => {
      let mail = doc.data()["userId"];
      let pushToken = doc.data()["pushToken"];
      console.log("pushToken: " + pushToken);
      let content;
      let title;
      console.log("Status: " + stAfter);

      if (stAfter == "Shipping") {
        title = "We have shipped your order and it is on the way";
        content = "Your order is on the way!!";
      } else if (stAfter == "Accept Order") {
        title = "Your order is accepted and being prepare";
        content =
          "Your order has been accepted and is being prepared, please wait";
      } else if (stAfter == "Done") {
        title = "Thank You for shopping with us!!";
        content =
          "We sending you a virtual hug and wishes of good health! Stay positive!";
      }

      var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
      };

      const payload = {
        notification: {
          title: title,
          body: content,
          badge: "1",
          sound: "default",
        },
        data: {
          title: title,
          body: content,
        },
      };

      admin
        .messaging()
        .sendToDevice(pushToken, payload, options)
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    });

    console.log(
      "----------------End Order Notification Function--------------------"
    );
    return null;
  });

exports.sendMessageNotification = functions.firestore
  .document("prescription/{preId}/note/{noteId}")
  .onWrite((snap) => {
    console.log(
      "----------------Start Message Notification Function--------------------"
    );

    const msg = snap.after.data()["msg"];
    const sender = snap.after.data()["mail"];

    console.log(msg);
    console.log(sender);

    if (sender == "customer@cs.com") {
    }

    const snapshot = admin.firestore().collection("UserActivity").doc(sender);
    snapshot
      .get()
      .then((doc) => {
        console.log(doc.data());
        if (doc.data() == null) {
          let pushToken = doc.data()["pushToken"];
          console.log("pushToken: " + pushToken);
          console.log("Status: " + stAfter);

          msg = "Customer Support: " + msg;

          const payload = {
            notification: {
              title: "You have new message",
              body: msg,
              badge: "1",
              sound: "default",
            },
            data: {
              title: "You have new message",
              body: msg,
            },
          };

          admin
            .messaging()
            .sendToDevice(pushToken, payload)
            .then((response) => {
              console.log("Successfully sent message:", response);
            })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
        }
      })
      .catch((error) => {
        console.log(error);
      });

    console.log(
      "----------------End Message Notification Function--------------------"
    );
    return null;
  });

// exports.testNotification = functions.firestore
//   .document("hi/{preId}")
//   .onWrite((snap) => {
//     const msg = snap.after.data()["demo"];
//     console.log("msg: " + msg);

//     const sender = snap.after.data()["mail"];

//     const snapshot = admin.firestore().collection("hi").doc("haha");
//     snapshot.get().then((doc) => {
//       console.log(doc.data() == null);
//     });
//   });
