import React, { useEffect, useState } from 'react';
import { createUserWithEmailAndPassword, updateProfile, updateEmail  } from 'firebase/auth';
import { auth, db } from './firebase';
import { doc, setDoc, updateDoc, /* deleteDoc */  } from 'firebase/firestore';
import { Button, Modal } from "flowbite-react";
import { toast } from "react-toastify";

const Register = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [displayName, setdisplayName] = useState('');
  const [userlist, setuserlist] = useState([]);
  const [updatecon, setupdatecon] = useState(false);
  const [createcon, setcreatecon] = useState(false);
  const [create, setcreate] = useState(false);
  const [update, setupdate] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const[showmodel, setshowmodel] = useState(false);
  const totalPages = Math.ceil(userlist.length / rowsPerPage);

  const backendbaseurl = process.env.REACT_APP_NODE_BACKEND_BASEURL

  useEffect(() => {
    fetchUsers();
  },[])

  const fetchUsers = async () => {
    try {
      const response = await fetch(`${backendbaseurl}/fire-users`); 
      const data = await response.json();
      setuserlist(data.reverse());
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  const createacc = async (e) => {
    setcreate(true)
    try {
      const usercreden = await createUserWithEmailAndPassword(auth, email, password);
      const getuser = usercreden.user;

      await updateProfile(getuser, {
        displayName : displayName,
      });

      await setDoc(doc(db, 'users', getuser.uid  ), {
        displayName,
        email,
        createdAt: new Date(),
      })
      
     
    } catch (error) {
      console.log("Error occurs ehile creating", error)
    }

    setcreatecon(false);
      clear();
      fetchUsers();
      setcreate(false)
      setshowmodel(false)
      toast.success("Customer acc created successfly")
  };

  const updateacc = async () => {
    setupdate(true)
    try {
      const currentUser = auth.currentUser;

      if (currentUser) {
          await updateProfile(currentUser, {
          displayName: displayName,
        });

        if (email !== currentUser.email) {
          await updateEmail(currentUser, email);
        }
          await updateDoc(doc(db, 'users', currentUser.uid), {
          displayName,
          email
        });

      }

      setupdatecon(false)
      fetchUsers();
      clear();
      setupdate(false)
    } catch (error) {
      console.error("Error updating user details: ", error);
    }

    setupdatecon(false)
      fetchUsers();
      clear();
      setshowmodel(false)
      toast.success("Customer acc Updated succesfully")
  };

 /*  const deleteacc = async (uid) => {
    try {
       await deleteDoc(doc(db, 'users', uid));
        fetchUsers();
    } catch (error) {
      console.error('Error deleting user: ', error);
      alert('Error deleting user. Please try again.');
    }
  }; */



  const updateconfirst = (e) => {
    setupdatecon(true)
    setEmail(e.email)
    setPassword(e.password)
    setdisplayName(e.displayName)
    setshowmodel(true)
  }

  const createconfirst = () => {
    setcreatecon(true)
    setEmail("")
    setPassword("")
    setdisplayName("")
    setshowmodel(true)
  }

  const clear = () => {
    setEmail("")
    setPassword("")
    setdisplayName("")
    setupdatecon(false)
    setcreatecon(false)
    setshowmodel(false)
  }

  const indexOfLastRow = currentPage * rowsPerPage;
  const indexOfFirstRow = indexOfLastRow - rowsPerPage;
  const currentRows = userlist.slice(indexOfFirstRow, indexOfLastRow);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const handleRowsPerPageChange = (e) => {
      const newRowsPerPage = Number(e.target.value);
      setRowsPerPage(newRowsPerPage);
      setCurrentPage(1); 
  };

  return (
    <div className="auth-container">
      <div className="header">
       <h2 className="text-white text-3xl">Account</h2>
       </div>

        <div className="secheader">

            <select className="select" id="rowsPerPage" value={rowsPerPage} onChange={handleRowsPerPageChange}>
                <option className="selectinner" value="10">10 Rows</option>
                <option className="selectinner" value="20">20 Rows</option>
                <option className="selectinner" value="50">50 Rows</option>
            </select>
            {
              updatecon ? (
                <>
                <input type = "text" placeholder = "Name" value = {displayName} onChange = {(e) => setdisplayName(e.target.value)} required />
                <input type = "email" placeholder = "Email" value = {email} onChange = {(e) => setEmail(e.target.value)} required />
                <button onClick={updateacc}>Update</button>
                <button onClick={clear}>Cancel</button>
                {update? <h4>Updating...</h4>:<h4> </h4>}
                </>

              ): createcon? (
                <>
                <input type = "text" placeholder = "Name" value = {displayName} onChange = {(e) => setdisplayName(e.target.value)} required />
                <input type = "email" placeholder = "Email" value = {email} onChange = {(e) => setEmail(e.target.value)} required />
                <input type = "password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} required />
                <button onClick={createacc}>Create</button>
                <button onClick={clear}>Cancel</button>
                {create? <h4>Creating...</h4>:<h4> </h4>}
                </>
              ):<button className="addbut" onClick={createconfirst}>
                  Add
                    <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22ZM12.75 9C12.75 8.58579 12.4142 8.25 12 8.25C11.5858 8.25 11.25 8.58579 11.25 9L11.25 11.25H9C8.58579 11.25 8.25 11.5858 8.25 12C8.25 12.4142 8.58579 12.75 9 12.75H11.25V15C11.25 15.4142 11.5858 15.75 12 15.75C12.4142 15.75 12.75 15.4142 12.75 15L12.75 12.75H15C15.4142 12.75 15.75 12.4142 15.75 12C15.75 11.5858 15.4142 11.25 15 11.25H12.75V9Z" fill="white"/>
                    </svg>
                </button>
            }
        </div>
        
      <div className="table1 ">
      <table className="tableout">
        <thead className="tablebgcolor">
          <tr className="py-14  h-16">
            <th className="tableheadcol" >S.no</th>
            <th className="tableheadcol" >Name</th>
            <th className="tableheadcol" >Email</th>
            {/* <th>Password</th> */}
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {
            currentRows.map((use, index) => (
              <tr key={use.uid} className={`py-14 h-20  ${index % 2 === 0 ? 'bg-white': 'bg-gray-100'} hover:bg-gray-200 `}>
                <td className="tableheadcol" >{index+1}</td>
                <td className="tableheadcol" >{use.displayName}</td>
                <td className="tableheadcol" >{use.email}</td>
                {/* <td>{use.password}</td> */}
                <td className="tableheadcol" >
                  <button className="updateview" onClick={() => updateconfirst(use)}>
                      <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M20.2071 3.79288C18.9882 2.57392 17.0119 2.57392 15.7929 3.79288L8.68463 10.9012C8.30015 11.2856 8.0274 11.7674 7.89552 12.2949L7.02988 15.7574C6.94468 16.0982 7.04453 16.4587 7.29291 16.7071C7.54129 16.9555 7.90178 17.0553 8.24256 16.9701L11.7051 16.1045C12.2326 15.9726 12.7144 15.6999 13.0988 15.3154L20.2071 8.20709C21.4261 6.98813 21.4261 5.01183 20.2071 3.79288Z" fill="white"/>
                          <path fill-rule="evenodd" clip-rule="evenodd" d="M2 7C2 4.23858 4.23858 2 7 2H12C12.5523 2 13 2.44772 13 3C13 3.55228 12.5523 4 12 4H7C5.34315 4 4 5.34315 4 7V17C4 18.6569 5.34315 20 7 20H17C18.6569 20 20 18.6569 20 17V12C20 11.4477 20.4477 11 21 11C21.5523 11 22 11.4477 22 12V17C22 19.7614 19.7614 22 17 22H7C4.23858 22 2 19.7614 2 17V7Z" fill="white"/>
                      </svg>
                  </button>
                  {/* <button onClick={() => deleteacc(use.uid)}>Delete</button> */}
                </td>
              </tr>
            ))
          }
        </tbody>
      </table>
      </div>
      <div className="flex flex-row items-center justify-center space-x-2 mt-4">
                <button onClick={() => paginate(currentPage - 1)} disabled={currentPage === 1}>
                    Previous
                </button>
            
                {Array.from({ length: totalPages }, (_, i) => (
                    <button
                    key={i}
                    onClick={() => paginate(i + 1)}
                    className={`px-3 py-1 rounded ${currentPage === i + 1 ? 'bg-teal-500 text-white' : 'bg-gray-200'}`}
                    >
                    {i + 1}
                    </button>
                ))}
            
                <button onClick={() => paginate(currentPage + 1)} disabled={currentPage === totalPages}>
                    Next
                </button>
            </div>

            <Modal show={showmodel} onClose={() => setshowmodel(false)} className="w-1/2  mx-auto ">
                <div className="innermodal">
                <Modal.Header className="">{updatecon? "Update" : "Add New"}</Modal.Header>
                <Modal.Body >
                <input className='modalinput' type = "text" placeholder = "Name" value = {displayName} onChange = {(e) => setdisplayName(e.target.value)} required />
                <input className='modalinput' type = "email" placeholder = "Email" value = {email} onChange = {(e) => setEmail(e.target.value)} required />
                <input className='modalinput' type = "password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} required />
                    
                </Modal.Body>
                <Modal.Footer className="footermd">
                
                <Button className="cancelmodal " onClick={(clear)}>Cancel</Button>
                <Button className="addmodal" onClick={updatecon? updateacc: createacc}>{updatecon? "Update" : "Add New"}</Button>
                </Modal.Footer>
                </div>
            </Modal>
    </div>
  );
};

export default Register;
