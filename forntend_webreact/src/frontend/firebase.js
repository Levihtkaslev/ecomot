// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from 'firebase/auth';
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyD5tYhYwg1R1rBsYW032lM1dBRF9o33zp4",
  authDomain: "itquality-b3e55.firebaseapp.com",
  projectId: "itquality-b3e55",
  storageBucket: "itquality-b3e55.firebasestorage.app",
  messagingSenderId: "244993085769",
  appId: "1:244993085769:web:a2ff85808cf725187f0a98",
  measurementId: "G-X6PGZJ8VR0"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

export { auth, db };