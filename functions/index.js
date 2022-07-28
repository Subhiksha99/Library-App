const functions = require("firebase-functions");
const admin=require('firebase-admin');
const algoliasearch=require('algoliasearch');

const ALGOLIA_APP_ID="MY2JNNMTAT";
const ALGOLIA_ADMIN_KEY="4da5854f6b3e0443666926580fb1d8e0";
const ALGOLIA_INDEX_NAME="multiple_pdf_search";

admin.initializeApp(functions.config().firebase);

exports.createPost=functions.firestore.
document('book/{2qUDe5wYNN2yLWBVWd8Z}')
.onCreate(async(snap,context)=>{
	const newValue=snap.data();
	newValue.objectID=snap.id;
	
	var client=algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
	
	var index=client.initIndex(ALGOLIA_INDEX_NAME);
	index.saveObject(newValue);
	console.log("Finished");
});

const newValue=snap.data();
newValue.objectID=snap.id;

var client=algoliasearch(ALGOLIA_INDEX_NAME);

var index=client.initIndex(ALGOLIA_INDEX_NAME);
index.saveObject(newValue);
console.log("Finished");

});
exports.updatePost=functions.firestore.
document('book/{2qUDe5wYNN2yLWBVWd8Z}')
.onUpdate(async(snap,context)=>{
	const afterUpdate=snap.after.data();
	afterUpdate.objectID=snap.id;
	
	var client=algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
	
	var index=client.initIndex(ALGOLIA_INDEX_NAME);
	index.saveObject(afterUpdate);
	console.log("Finished");
});

exports.deletePost=functions.firestore.
document('book/{2qUDe5wYNN2yLWBVWd8Z}')
.onDelete(async(snap,context)=>{
	const oldID=snap.id;
	
	var client=algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
	
	var index=client.initIndex(ALGOLIA_INDEX_NAME);
	index.deleteObject(afterUpdate);
	console.log("Finished");
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
   functions.logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
 });
