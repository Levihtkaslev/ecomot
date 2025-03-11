import React from 'react';
import { Link } from 'react-router-dom';

const Otmenu = () => {

    return(
        <nav>
            <ul>
                <li>
                    <Link to="/">Request</Link>
                </li>
                <li>
                    <Link to="/items-list">Products</Link>
                </li>
                <li>
                    <Link to="/user-account">User Role</Link>
                </li>
                <li>
                    <Link to="/category-list">Category</Link>
                </li>
                <li>
                    <Link to="/patient-account">Patient Account</Link>
                </li>
                <li>
                    <Link to="/patient-personal">Personal</Link>
                </li>
                <li>
                    <Link to="/report">Reports</Link>
                </li>
            </ul>
        </nav>
    )
}

export default Otmenu;