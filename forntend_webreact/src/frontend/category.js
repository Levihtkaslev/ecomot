import React, {useState, useEffect} from "react";
import * as XLSX from "xlsx";
import { Button, Modal } from "flowbite-react";
import { toast } from "react-toastify";
import { HiOutlineExclamationCircle } from "react-icons/hi";

const Category = () => {

    const[category, setcategory] = useState([]);
    const[categoryname, setcategoryname] = useState("");
    const[createconfirmbox, setcreateconfirmbox] = useState(false);
    const[editcatagory, seteditcatagory] = useState("");
    const[editcatag, seteditcatag] = useState(false);
    const[catsearch, setcatsearch] = useState("");
    const[currentPage, setCurrentPage] = useState(1);
    const[rowsPerPage, setRowsPerPage] = useState(10);
    const[showmodel, setshowmodel] = useState(false);
    const[deleteid, setdeleteid] = useState('');
    const[showdelmodel, setshowdelmodel] = useState(false);
    
    const totalPages = Math.ceil(category.length / rowsPerPage);

    const backendbaseurl = process.env.REACT_APP_NODE_BACKEND_BASEURL

    useEffect(() => {
        getcategory();
        },[catsearch]
    );

    const getcategory = async () => {
        const categ = await fetch(`${backendbaseurl}/web/category`);
        const categlist = await categ.json();

        const filter = categlist.filter(cat => {
            const search = catsearch === ""  || cat.categname.toLowerCase().includes(catsearch.toLowerCase())
            return(search)
        })

        setcategory(filter.reverse());
    };

    const createcat = async () => {
        await fetch(`${backendbaseurl}/web/category`, {
            method : "POST",
            headers : {
                "content-type" : "application/json"
            },
            body : JSON.stringify({categname : categoryname}),
        });
        setcategoryname("");
        getcategory();
        setcreateconfirmbox(false);
        setshowmodel(false)
        toast.success("Category added successfully!");
    }

    const updatecatt = async () => {
        await fetch(`${backendbaseurl}/web/category/${editcatagory._id}`, {
            method : "PUT",
            headers : {
                "content-type" : "application/json"
            },
            body : JSON.stringify({categname : categoryname}),
        });
        setcategoryname("");
        getcategory();
        seteditcatag(false);
        setshowmodel(false)
        toast.success("Category updated successfully!")
    }

    const deletecat = async (id) => {
        
        await fetch(`${backendbaseurl}/web/category/${id}`,{
            method : "DELETE",
        });
        getcategory();
        toast.success("Category deleted successfully")
        setshowdelmodel(false)
    }

    const updatecat = async (cat) => {
        setshowmodel(true)
        seteditcatagory(cat)
        setcategoryname(cat.categname);
        seteditcatag(true);
    }

    const catagfirst = () => {
        setshowmodel(true);
        setcreateconfirmbox(true);
    }

    const catagclear = () => {
        setcategoryname("");
        setcreateconfirmbox(false);
        seteditcatag(false);
        setshowmodel(false)
        setshowdelmodel(false)
    }

        const exportt = () => {
            if (category.length === 0) {
                alert("No data to export!");
                return;
            }
    
            const worksheet = XLSX.utils.json_to_sheet(category);
            const workbook = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(workbook, worksheet, "Items");
            XLSX.writeFile(workbook, "FilteredItems.xlsx");
            toast.success("Document dowloaded Successfully")
        }

    const indexOfLastRow = currentPage * rowsPerPage;
    const indexOfFirstRow = indexOfLastRow - rowsPerPage;
    const currentRows = category.slice(indexOfFirstRow, indexOfLastRow);

    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    const handleRowsPerPageChange = (e) => {
        const newRowsPerPage = Number(e.target.value);
        setRowsPerPage(newRowsPerPage);
        setCurrentPage(1); 
    };

    const deletemodel = (id) => {
        setshowdelmodel(true)
        setdeleteid(id)
    }
    

    return(
        <div >
            <div className="header">
                <h3 className="text-white text-3xl">Category</h3>
            </div>
            <div className="secheader">
                <div className="searchout">
                    <input className="searchinner" value={catsearch} onChange={(e) => setcatsearch(e.target.value)} placeholder="search category"/>
                    <svg 
                                width="24" 
                                height="24" 
                                viewBox="0 0 24 24" 
                                fill="none" 
                                xmlns="http://www.w3.org/2000/svg"
                                className="text-teal-500 mr-2"
                            >
                                <circle cx="10.5" cy="10.5" r="6.5" stroke="currentColor" strokeLinejoin="round"/>
                                <path 
                                d="M19.65 20.35a.5.5 0 0 0 .71-.71l-5-5-.71.71 5 5Z" 
                                fill="currentColor"
                                />
                    </svg>
                </div>

                <div className="flex w-1/4 justify-between">

                <select className="select" id="rowsPerPage" value={rowsPerPage} onChange={handleRowsPerPageChange}>
                    <option className="selectinner" value="10">10 Rows</option>
                    <option className="selectinner" value="20">20 Rows</option>
                    <option className="selectinner" value="50">50 Rows</option>
                </select>

                        <button className="addbut" onClick={catagfirst}>
                            Add
                            <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22ZM12.75 9C12.75 8.58579 12.4142 8.25 12 8.25C11.5858 8.25 11.25 8.58579 11.25 9L11.25 11.25H9C8.58579 11.25 8.25 11.5858 8.25 12C8.25 12.4142 8.58579 12.75 9 12.75H11.25V15C11.25 15.4142 11.5858 15.75 12 15.75C12.4142 15.75 12.75 15.4142 12.75 15L12.75 12.75H15C15.4142 12.75 15.75 12.4142 15.75 12C15.75 11.5858 15.4142 11.25 15 11.25H12.75V9Z" fill="white"/>
                            </svg>
                          </button>
                        

                        <button className="exportbut" onClick={exportt}>
                            Export
                            <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M9.163 2.819C9 3.139 9 3.559 9 4.4V11H7.803c-.883 0-1.325 0-1.534.176a.75.75 0 0 0-.266.62c.017.274.322.593.931 1.232l4.198 4.401c.302.318.453.476.63.535a.749.749 0 0 0 .476 0c.177-.059.328-.217.63-.535l4.198-4.4c.61-.64.914-.96.93-1.233a.75.75 0 0 0-.265-.62C17.522 11 17.081 11 16.197 11H15V4.4c0-.84 0-1.26-.164-1.581a1.5 1.5 0 0 0-.655-.656C13.861 2 13.441 2 12.6 2h-1.2c-.84 0-1.26 0-1.581.163a1.5 1.5 0 0 0-.656.656zM5 21a1 1 0 0 0 1 1h12a1 1 0 1 0 0-2H6a1 1 0 0 0-1 1z" fill="white"/>
                            </svg>
                        </button>
                </div>
            </div>
            <div className="table1">
            <table className="tableout">
                <thead className="tablebgcolor">
                    <tr className="py-14  h-16">
                        <th className="tableheadcol" >S.no</th>
                        <th className="tableheadcol" >Category</th>
                        <th className="tableheadcol" >Actions</th>
                    </tr>
                </thead>

                
                <tbody>
                    {
                        currentRows.map((cat, index) => (
                            <tr key={cat._id} className={`py-14 h-2  ${index % 2 === 0 ? 'bg-white': 'bg-gray-100'} hover:bg-gray-200 `}>
                            <td className="tableheadcol" >{index+1}</td>
                            <td className="tableheadcol" >{cat.categname}</td>
                            <td className="tableheadcol">
                               <button className="updateview" onClick={() => updatecat(cat)}>
                               <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M20.2071 3.79288C18.9882 2.57392 17.0119 2.57392 15.7929 3.79288L8.68463 10.9012C8.30015 11.2856 8.0274 11.7674 7.89552 12.2949L7.02988 15.7574C6.94468 16.0982 7.04453 16.4587 7.29291 16.7071C7.54129 16.9555 7.90178 17.0553 8.24256 16.9701L11.7051 16.1045C12.2326 15.9726 12.7144 15.6999 13.0988 15.3154L20.2071 8.20709C21.4261 6.98813 21.4261 5.01183 20.2071 3.79288Z" fill="white"/>
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M2 7C2 4.23858 4.23858 2 7 2H12C12.5523 2 13 2.44772 13 3C13 3.55228 12.5523 4 12 4H7C5.34315 4 4 5.34315 4 7V17C4 18.6569 5.34315 20 7 20H17C18.6569 20 20 18.6569 20 17V12C20 11.4477 20.4477 11 21 11C21.5523 11 22 11.4477 22 12V17C22 19.7614 19.7614 22 17 22H7C4.23858 22 2 19.7614 2 17V7Z" fill="white"/>
                                </svg>
                               </button> 
                               <button className="rowdel"  onClick={() => deletemodel(cat._id)}>
                                    <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M3 6.38597C3 5.90152 3.34538 5.50879 3.77143 5.50879L6.43567 5.50832C6.96502 5.49306 7.43202 5.11033 7.61214 4.54412C7.61688 4.52923 7.62232 4.51087 7.64185 4.44424L7.75665 4.05256C7.8269 3.81241 7.8881 3.60318 7.97375 3.41617C8.31209 2.67736 8.93808 2.16432 9.66147 2.03297C9.84457 1.99972 10.0385 1.99986 10.2611 2.00002H13.7391C13.9617 1.99986 14.1556 1.99972 14.3387 2.03297C15.0621 2.16432 15.6881 2.67736 16.0264 3.41617C16.1121 3.60318 16.1733 3.81241 16.2435 4.05256L16.3583 4.44424C16.3778 4.51087 16.3833 4.52923 16.388 4.54412C16.5682 5.11033 17.1278 5.49353 17.6571 5.50879H20.2286C20.6546 5.50879 21 5.90152 21 6.38597C21 6.87043 20.6546 7.26316 20.2286 7.26316H3.77143C3.34538 7.26316 3 6.87043 3 6.38597Z" fill="white"/>
                                        <path fill-rule="evenodd" clip-rule="evenodd" d="M11.5956 22.0001H12.4044C15.1871 22.0001 16.5785 22.0001 17.4831 21.1142C18.3878 20.2283 18.4803 18.7751 18.6654 15.8686L18.9321 11.6807C19.0326 10.1037 19.0828 9.31524 18.6289 8.81558C18.1751 8.31592 17.4087 8.31592 15.876 8.31592H8.12404C6.59127 8.31592 5.82488 8.31592 5.37105 8.81558C4.91722 9.31524 4.96744 10.1037 5.06788 11.6807L5.33459 15.8686C5.5197 18.7751 5.61225 20.2283 6.51689 21.1142C7.42153 22.0001 8.81289 22.0001 11.5956 22.0001ZM10.2463 12.1886C10.2051 11.7548 9.83753 11.4382 9.42537 11.4816C9.01321 11.525 8.71251 11.9119 8.75372 12.3457L9.25372 17.6089C9.29494 18.0427 9.66247 18.3593 10.0746 18.3159C10.4868 18.2725 10.7875 17.8856 10.7463 17.4518L10.2463 12.1886ZM14.5746 11.4816C14.9868 11.525 15.2875 11.9119 15.2463 12.3457L14.7463 17.6089C14.7051 18.0427 14.3375 18.3593 13.9254 18.3159C13.5132 18.2725 13.2125 17.8856 13.2537 17.4518L13.7537 12.1886C13.7949 11.7548 14.1625 11.4382 14.5746 11.4816Z" fill="white"/>
                                    </svg>
                               </button>
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
                <Modal.Header className="">{editcatag? "Update" : "Add New"}</Modal.Header>
                <Modal.Body >
                
                    <input placeholder="Category name" className='modalinput' value={categoryname} onChange={(a) => setcategoryname(a.target.value)} />
                
                </Modal.Body>
                <Modal.Footer className="footermd">
                
                <Button className="cancelmodal " onClick={(catagclear)}>Cancel</Button>
                <Button className="addmodal" onClick={editcatag? updatecatt: createcat}>{editcatag? "Update" : "Add"}</Button>
                </Modal.Footer>
                </div>
            </Modal>

            <Modal show={showdelmodel} className="w-1/3  mx-auto ">
                <div className="innermodal">
                <Modal.Header className="flex justify-center"><HiOutlineExclamationCircle className="modalicon" /></Modal.Header>
                <Modal.Body className="modaldel">
                    Are you sure want to delete?
                </Modal.Body>
                <Modal.Footer className="modalfooter">
                
                <Button className="cancelmodal " onClick={(catagclear)}>Wait..wait..</Button>
                <Button className="addmodal" onClick={()=> deletecat(deleteid)}>Yes.. Do it</Button>
                </Modal.Footer>
                </div>
            </Modal>




        </div>
    );
};

export default Category;