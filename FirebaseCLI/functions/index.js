const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const ref = admin.firestore()

exports.createUserAccount = functions.auth.user().onCreate(event => {
    const newUserRef = ref.child('/users/${uid}');
    return newUserRef.set({
        email: "cookADish@gmail.com",
        photoUrl: "null@null.com"
    })
})

exports.noteShare = functions.https.onRequest((request, response) => {
 response.send("Hello from actual note share app, please use this link in future!\nDeveloped By Prato Das, Sumit Somani\nDesigner: @null");
});


