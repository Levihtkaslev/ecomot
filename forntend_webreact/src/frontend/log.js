import React, { useState } from 'react';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from './firebase';
import { useNavigate } from 'react-router-dom';


const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();

    try {
      await signInWithEmailAndPassword(auth, email, password);
      
      navigate('/dashboard');
    } catch (error) {
      
    }
  };

  return (
    <div className="shadow-lg  w-1/3 mt-72 m-auto rounded border-2  border-gray-300 p-11 ">
        <div className='flex justify-between  items-center'>
           <h2 className='py-5 text-4xl text-teal-600 text'>Login</h2>
           <div className='h-14 w-14'>
            <img src='https://media-hosting.imagekit.io//53bca07c48d24d25/otlogo1.png?Expires=1835261649&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=x2gAL7THwE4EIddoFjelsrhP88dN6f1oHJk8ohDj-dJEkz-SIjJACdhOBpd6e0cpxSXKltE3d7tUhzqIBmZF3iJVHd0o2vdLQdeiZvNzDbZhltqmXVbEnKU-WvbCmyGmHVbTOGZzbNzqWdq545vUyJjH9fSVh~s14wfK8pR0L-KqrG-FawvRZ51iCQxvP0aLRRa0vM38oc0lq0KcvrRs8T19ygcc5yYGkX5SQVsgSS5boVtsgCPUL1lEAr22v04ODCQ3APrIonfABdLACLUHoJr0AaH77kfvNeiNTn6P-yDf07EENjGiWz30-L5uMZXP5Tl193D3Fi8i9DKuPzqNcA__' alt="Network Image"/>
          </div>
        </div>

        <form className='flex flex-col justify-center ' onSubmit={handleLogin}>
        <h2 className='text-blue-600 text-xl pb-2 pt-3'>Username</h2>
          
          
          <div className="searchout">
            <input className="searchinner"
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
              
          </div>
          
          <h2 className='text-blue-600 text-xl pb-2 pt-3'>Password</h2>
          <div className="searchout">
              
                <input className="searchinner"
                  type={showPassword? "text" :  "password"}
                  placeholder="Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required  
                />
                <button className='px-4' type="button" onClick={() => setShowPassword(!showPassword)}>{showPassword ? 
                <svg fill="orange" width="30px" height="30px" viewBox="0 0 256 256" id="Flat" xmlns="http://www.w3.org/2000/svg">
                  <path d="M247.31055,131.25647c-.41992.94531-10.54688,23.37207-33.35938,43.80566a8.00126,8.00126,0,0,1-11.25781-.57715L101.40234,63.06506a8.00028,8.00028,0,0,1,4.60254-13.27246A133.97063,133.97063,0,0,1,128,47.99963c34.87793,0,66.57324,13.26075,91.65723,38.34766,18.834,18.83594,27.30175,37.62109,27.65332,38.41113A8.00282,8.00282,0,0,1,247.31055,131.25647ZM213.91992,210.6178a8.0006,8.0006,0,0,1-11.83984,10.76367l-22.01441-24.21582A126.97091,126.97091,0,0,1,128,207.99963c-34.87793,0-66.57227-13.25781-91.65625-38.33886-18.834-18.832-27.30273-37.61329-27.6543-38.4043a8.00282,8.00282,0,0,1,0-6.49805c.69556-1.564,16.31079-35.9209,52.63184-58.21191l-19.24121-21.165A8.0006,8.0006,0,1,1,53.91992,34.6178ZM145.6814,159.34289l-47.20459-51.9248a35.98114,35.98114,0,0,0,47.20459,51.9248Z"/>
                </svg>
                  : 
                <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path fill-rule="evenodd" clip-rule="evenodd" d="M1.5 12c0-2.25 3.75-7.5 10.5-7.5S22.5 9.75 22.5 12s-3.75 7.5-10.5 7.5S1.5 14.25 1.5 12zM12 16.75a4.75 4.75 0 1 0 0-9.5 4.75 4.75 0 0 0 0 9.5zM14.7 12a2.7 2.7 0 1 1-5.4 0 2.7 2.7 0 0 1 5.4 0z" fill="green"/>
                </svg>
                  }
                </button>
             
          </div>
          

          

          <button className='bg-cyan-400 p-5 w-full rounded-3xl shadow-2xl hover:bg-teal-500 transition duration-300 text-2xl text-white mt-11 ' type="submit">Login</button>
                
        </form>
    </div>
  );
};

export default Login;
