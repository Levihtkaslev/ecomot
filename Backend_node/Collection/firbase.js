var admin = require("firebase-admin");

var serviceAccount = require("./firebasesecret.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://itquality-b3e55-default-rtdb.asia-southeast1.firebasedatabase.app"
});

module.exports = admin;