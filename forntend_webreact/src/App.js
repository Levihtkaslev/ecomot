/* import Category from './frontend/category';
import Otuser from './frontend/otuser';
import Useracc from './frontend/useracc';
import Personal from './frontend/personal';
import Items from './frontend/item';
import Buy from './frontend/buy';
import Otreport from './frontend/report';
import Otmenu from './frontend/menu'; */

import React, { useEffect, useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { onAuthStateChanged } from 'firebase/auth';
import {auth} from './frontend/firebase'
import Login from './frontend/log';
import Dashboard from './frontend/nav';
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

function App() {
  const [user, setUser] = useState(null); 
  const [loading, setLoading] = useState(true); 

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setLoading(false); 
    });

    return () => unsubscribe(); 
  }, []);

  if (loading) {
    return <div>Loading...</div>; 
  }

  

  return (
    <BrowserRouter>
      <Routes>
        {/* Public routes */}
        <Route path = "/" element = {user ? <Navigate to = "/dashboard" /> : <Login />}
        />

        {/* Private route for the dashboard */}
        
        <Route path = "/dashboard/*" element = {user ? <Dashboard /> : <Navigate to = "/" />}
        />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
