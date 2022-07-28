const func=require('firebase-functions');
const admin=require('firebase-admin');
const algoliasearch=require('algoliasearch');

const ALGOLIA_APP_ID="MY2JNNMTAT";
const ALGOLIA_ADMIN_KEY="4da5854f6b3e0443666926580fb1d8e0";
const ALGOLIA_INDEX_NAME="multiple_pdf_search";

admin.initializeApp(func.config().firebase);
exports.createSearch=func.firestore.document('1/{cnkurose10}').onCreate(async(snap,context)=>{
const newValue=snap.data();
newValue.objectID=snap.id;

var client=algoliasearch(ALGOLIA_INDEX_NAME);

var index=client.initIndex(ALGOLIA_INDEX_NAME);
index.saveObject(newValue);
console.log("Finished");

});
