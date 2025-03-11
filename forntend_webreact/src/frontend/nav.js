import React, { useState, useEffect } from 'react';
import { Routes, Route } from 'react-router-dom';
import { NavLink, useNavigate } from 'react-router-dom';
import { signOut } from 'firebase/auth';
import { auth } from './firebase';
import Category from './category';
import Otuser from './otuser';
import Useracc from './useracc';
import Personal from './personal';
import Items from './item';
import Buy from './buy';
import Otreport from './report';
import Register from './reg';
import Coreimage from './coreimage';
import { FaClipboardList, FaInfoCircle } from "react-icons/fa";
import { IoIosCreate } from "react-icons/io";
import { BiSolidCategory } from "react-icons/bi";
import { HiUserAdd, HiDocumentReport  } from "react-icons/hi";
import { FaRegIdBadge } from "react-icons/fa6";
import { MdAdminPanelSettings } from "react-icons/md";
import { GiKnightBanner } from "react-icons/gi";
import { RiLogoutBoxRFill } from "react-icons/ri";
import { Bounce, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

function Dashboard() {
  const [token, setToken] = useState(null); 
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await signOut(auth);
      localStorage.removeItem('authToken');
      navigate('/');
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  
  const getToken = async () => {
    const user = auth.currentUser;
    if (user) {
      const token = await user.getIdToken();
      setToken(token); 
      console.log('JWT Token:', token);
    } else {
      console.log('No user is logged in');
    }
  };

  useEffect(() => {
    getToken();
  }, []); 

  const menulist = [
    { name: 'Request', path: '/dashboard/buy', icon: <FaClipboardList /> },
    { name: 'List', path: '/dashboard/items-list', icon: <IoIosCreate /> },
    { name: 'Type', path: '/dashboard/category-list', icon: <BiSolidCategory /> },
    { name: 'Old User Acc', path: '/dashboard/user-account', icon: <HiUserAdd /> },
    { name: 'Customer Acc', path: '/dashboard/patient-account', icon: <FaRegIdBadge /> },
    { name: 'Pat Info', path: '/dashboard/patient-personal', icon: <FaInfoCircle /> },
    { name: 'Report', path: '/dashboard/report', icon: <HiDocumentReport /> },
    { name: 'Admin Account', path: '/dashboard/reg', icon: <MdAdminPanelSettings /> },
    { name: 'Carousels', path: '/dashboard/corosel', icon: <GiKnightBanner />  },
  ];


  return (
    <div className="flex h-screen">
      {/* Sidebar */}
      <nav className="w-72  bg-gray-800 text-white p-5 flex flex-col justify-between ">
      <div>
        {/* Logo and title */}
        <div className="flex items-center justify-center mb-6">
          
          <img
            className="h-11 w-11 ml-2"
            src="https://media-hosting.imagekit.io//53bca07c48d24d25/otlogo1.png?Expires=1835261649&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=x2gAL7THwE4EIddoFjelsrhP88dN6f1oHJk8ohDj-dJEkz-SIjJACdhOBpd6e0cpxSXKltE3d7tUhzqIBmZF3iJVHd0o2vdLQdeiZvNzDbZhltqmXVbEnKU-WvbCmyGmHVbTOGZzbNzqWdq545vUyJjH9fSVh~s14wfK8pR0L-KqrG-FawvRZ51iCQxvP0aLRRa0vM38oc0lq0KcvrRs8T19ygcc5yYGkX5SQVsgSS5boVtsgCPUL1lEAr22v04ODCQ3APrIonfABdLACLUHoJr0AaH77kfvNeiNTn6P-yDf07EENjGiWz30-L5uMZXP5Tl193D3Fi8i9DKuPzqNcA__"
            alt="Network Image"
          />
          <h2 className="text-xl font-bold text-center">Dashboard</h2>
        </div>

        {/* Menu items */}
        <ul className="space-y-2">
          {menulist.map((item) => (
            <li key={item.path} className="w-full">
              <NavLink
                to={item.path}
                className={({ isActive }) =>
                  ` w-full p-3 rounded text-white flex gap-4 items-center transition duration-300 ${
                    isActive ? "bg-pink-600" : "hover:bg-gray-700"
                  }`
                }
              >
                {item.icon}
                {item.name}
              </NavLink>
            </li>
          ))}
        </ul>
      </div>

      {/* Sign Out button */}
      <button
        onClick={handleLogout}
        className="mt-5 bg-pink-600 hover:bg-pink-700 text-white py-2 px-4 rounded flex justify-evenly items-center"
      >
        Sign Out
        <RiLogoutBoxRFill />
      </button>
    </nav>


      {/* Main Content */}
      <div className="flex-1 p-10 bg-gray-100 overflow-y-auto">
      <ToastContainer theme='dark' position='top-center' autoClose={2000} hideProgressBar={false} newestOnTop={true} closeOnClick transition={Bounce} draggable/>
        <Routes>
          <Route index element={<Buy />} />
          <Route path="buy" element={<Buy />} />
          <Route path="items-list" element={<Items />} />
          <Route path="category-list" element={<Category />} />
          <Route path="user-account" element={<Otuser />} />
          <Route path="patient-account" element={<Useracc />} />
          <Route path="patient-personal" element={<Personal />} />
          <Route path="report" element={<Otreport />} />
          <Route path="reg" element={<Register />} />
          <Route path="corosel" element={<Coreimage />} />
        </Routes>
      </div>
      
    </div>
  );
}

export default Dashboard;
