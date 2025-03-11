import React, {useState, useEffect} from "react";
import * as XLSX from "xlsx";
import Datepicker from "react-tailwindcss-datepicker";
import { toast } from "react-toastify";
import { Button, Modal } from "flowbite-react";
import { HiOutlineExclamationCircle } from "react-icons/hi";

const Buy = () => {
    
    const[buylist, setbuylist] = useState([]);
    const[assign, setassign] = useState([]);
    const[category, setcategory] = useState([]);
    const[selectedValues, setSelectedValues] = useState({});
    const[buysearch, setbuysearch] = useState("");
    const[assi, setassi] = useState("");
    const[cat, setcat] = useState("");
    const[sts, setsts] = useState("");
    const[viewcart, setviewcart] = useState([]);
    const[box, setbox] = useState(false);
    const[status, setstatus] = useState("");
    const[disable, setdisable] = useState('');
    const[value, setValue] = useState({startDate: null,endDate: null});
    const[deleteid, setdeleteid] = useState('');
    const[showmodel, setshowmodel] = useState(false);
    const [dateRange, setDateRange] = useState({
        startDate: null,
        endDate: null,
    });

    const [currentPage, setCurrentPage] = useState(1);
    const [rowsPerPage, setRowsPerPage] = useState(10);
    
    const totalPages = Math.ceil(buylist.length / rowsPerPage);

    const backendbaseurl = process.env.REACT_APP_NODE_BACKEND_BASEURL

    useEffect(() => {
        getbuylist();
        getassing();
        getcategory();
    },[buysearch, assi, cat, sts]);



    const getassing = async () => {
        const response = await fetch(`${backendbaseurl}/otuser`);
        const res = await response.json();
        setassign(res);
    }

    const getcategory = async () => {
        const categ = await fetch(`${backendbaseurl}/web/category`);
        const categlist = await categ.json();
        setcategory(categlist);
    };

    const getbuylist = async (start = null, end = null) => {
        const response = await fetch(`${backendbaseurl}/buy`);
        const res = await response.json();

        

        const filter = res.filter(res => {
            const assigneefill = assi === "" || res.itemassinged === assi; 
            const catfill = cat === "" || res.itemcategory === cat;
            const stsfill = sts === "" || res.itemstatus === sts;
            const searchfill = buysearch === "" || res.personname.toLowerCase().includes(buysearch.toLowerCase())
                                                || res.personnumber.toLowerCase().includes(buysearch.toLowerCase())
            const formDate = new Date(res.createdAt).setHours(0, 0, 0, 0);
            const startDateOnly = start ? new Date(start).setHours(0, 0, 0, 0) : null;
            const endDateOnly = end ? new Date(end).setHours(0, 0, 0, 0) : null;
            const datefill = (!start || formDate >= startDateOnly) && (!end || formDate <= endDateOnly);
            return(searchfill && assigneefill && catfill && stsfill && datefill)
        })

        const sortedData = filter.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
        setbuylist(sortedData);
        console.log(sortedData); 
    }

    const handleDateChange = (newValue) => {
        setDateRange(newValue);
        getbuylist(newValue.startDate, newValue.endDate);
    };

    const deletebuy = async (id) => {
        await fetch(`${backendbaseurl}/buy/${id}`,{
            method : "DELETE",
        });
        getbuylist();
        setshowmodel(false)
        toast.success("Deleted Successfully")
    }

    const handleSelectChange = (_id, value) => {
        setSelectedValues((prev) => ({
          ...prev,
          [_id]: value, 
        }));
      };

    const formatDate = (dateString) => {
        return new Date(dateString).toLocaleString('en-GB');
    };

    const sttatus = async(_id, currentstatus) => {
        

        await fetch(`${backendbaseurl}/updateassignee/${_id}`, {
            method: "PATCH", 
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                itemstatus: currentstatus, 
                
            }),
        });
        getbuylist();
        setstatus("");
        setdisable(true);
    }

      const handleSubmit = async(_id) => {
        const selectedValue = selectedValues[_id]; 
      
        if (!selectedValue) {
          alert("Please select a value before submitting!");
          return;
        }
      
        
        await fetch(`${backendbaseurl}/updateassignee/${_id}`, {
          method: "PATCH", 
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            itemassinged: selectedValue, 
          }),
        });
        getbuylist();
      };


    const exportt = () => {
        if (buylist.length === 0) {
            alert("No data to export!");
            return;
        }

        const worksheet = XLSX.utils.json_to_sheet(buylist);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Items");
        XLSX.writeFile(workbook, "oreddetaile.xlsx");
        toast.success("Document dowloaded Successfully")
    }

    const targetview = (e) => {
        setviewcart(e);
        setbox(true);
    }

    const cancel = () => {
        setcat("");
        setassi("");
        setsts("");
        setbuysearch ("");
        setviewcart([]);
        setbox(false);
        toast.error("Canceled")
        setshowmodel(false)
        setRowsPerPage(10)
    }
      
    const deletemodel = (id) => {
        setshowmodel(true)
        setdeleteid(id)
    }

    const indexOfLastRow = currentPage * rowsPerPage;
    const indexOfFirstRow = indexOfLastRow - rowsPerPage;
    const currentRows = buylist.slice(indexOfFirstRow, indexOfLastRow);

    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    const handleRowsPerPageChange = (e) => {
        setRowsPerPage(Number(e.target.value));
        setCurrentPage(1);
    };

    return (

        <div className="">
            <div className= " header">
                <h3 class="text-white text-3xl ">Request</h3>
                <div className="w-1/6 ">
                    <Datepicker 
                            value={dateRange} 
                            onChange={handleDateChange}
                            showShortcuts={true}
                            inputClassName="rounded p-2 w-full text-gray  bg-white focus:outline-none px-3"
                        /> 
                </div>
            </div>

            <div className="secheader">
                <div className="searchout">
                    <input 
                        className="searchinner"
                        value={buysearch} 
                        onChange={(e) => setbuysearch(e.target.value)} 
                        placeholder="Search"
                    />
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

                

               <div className="flex w-1/2 justify-between">

                <select className="select" id="rowsPerPage" value={rowsPerPage} onChange={handleRowsPerPageChange}>
                    <option className="selectinner" value="10">10 Rows</option>
                    <option className="selectinner" value="20">20 Rows</option>
                    <option className="selectinner" value="50">50 Rows</option>
                </select>
               <select className="select" value={assi} onChange={(e) => setassi(e.target.value)}>
                    <option className="selectinner" value = "">All Assignee</option>
                    {
                        assign.map(assign => (<option className="selectinner" value={assign.otusername} key={assign._id}>{assign.otusername}</option>))
                    }
                </select>
                <select className="select" value={cat} onChange={(e) => setcat(e.target.value)}>
                    <option className="selectinner" value = "">All Category</option>
                    {
                        category.map(assign => (<option className="selectinner" value={assign.categname} key={assign._id}>{assign.categname}</option>))
                    }
                </select>
                <select className="select" value={sts}  onChange={(e) => setsts(e.target.value)} >
                    <option className="selectinner" value = "">All Status</option>
                    <option className="selectinner" value = "pending">Pending</option>
                    <option className="selectinner" value = "complete">Complete</option>
                    <option className="selectinner" value = "canceled">Canceled</option>
                </select>
                <button className="clearbut" onClick={cancel}>
                    Clear
                    <svg fill="white" width="25px" height="25px" viewBox="0 0 56 56" xmlns="http://www.w3.org/2000/svg">
                        <path d="M 13.7851 49.5742 L 42.2382 49.5742 C 47.1366 49.5742 49.5743 47.1367 49.5743 42.3086 L 49.5743 13.6914 C 49.5743 8.8633 47.1366 6.4258 42.2382 6.4258 L 13.7851 6.4258 C 8.9101 6.4258 6.4257 8.8398 6.4257 13.6914 L 6.4257 42.3086 C 6.4257 47.1602 8.9101 49.5742 13.7851 49.5742 Z M 19.6913 38.3711 C 18.5429 38.3711 17.5820 37.4336 17.5820 36.2852 C 17.5820 35.7461 17.8163 35.2305 18.2382 34.8086 L 25.0351 27.9649 L 18.2382 21.1445 C 17.8163 20.7227 17.5820 20.2071 17.5820 19.6680 C 17.5820 18.4961 18.5429 17.5352 19.6913 17.5352 C 20.2539 17.5352 20.7460 17.7461 21.1679 18.1680 L 28.0117 25.0118 L 34.8554 18.1680 C 35.2539 17.7461 35.7695 17.5352 36.3085 17.5352 C 37.4804 17.5352 38.4413 18.4961 38.4413 19.6680 C 38.4413 20.2071 38.2070 20.7227 37.7851 21.1445 L 30.9648 27.9649 L 37.7851 34.8086 C 38.2070 35.2305 38.4413 35.7461 38.4413 36.2852 C 38.4413 37.4336 37.4804 38.3711 36.3085 38.3711 C 35.7695 38.3711 35.2539 38.1602 34.8788 37.7852 L 28.0117 30.8945 L 21.1444 37.7852 C 20.7460 38.1602 20.2773 38.3711 19.6913 38.3711 Z"/>
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
                <thead className="tablebgcolor ">
                    <tr className="py-14  h-16">
                        <th className="tableheadcol">S.no</th>
                        <th className="tableheadcol">Time</th>
                        <th className="tableheadcol">Patient Name</th>
                        <th className="tableheadcol">Item Name</th>
                        <th className="tableheadcol">Quantity</th>
                        <th className="tableheadcol">Price</th>
                        <th className="text-center w-1/5">Location</th>
                        <th className="tableheadcol">Status</th>
                        <th className="tableheadcol">Category</th>
                        <th className="tableheadcol">Phone Number</th>
                        <th className="tableheadcol">Assign</th>
                        <th className="tableheadcol">Assign to</th>
                        <th className="tableheadcol">Change Status</th>
                        <th className="w-16 text-center px-12">View</th>
                        <th className="w-16 text-center px-8">Cancel</th>
                    </tr>
                </thead>
                <tbody>
                    {
                        currentRows.map((buy, index) => (
                            <tr className={`py-14 h-20  ${index % 2 === 0 ? 'bg-white': 'bg-gray-100'} hover:bg-gray-200 `} key={buy._id}>
                                <td className="tableheadcol">{index+1}</td>
                                <td className="tableheadcol">{formatDate(buy.createdAt)}</td>
                                <td className="tableheadcol">{buy.personname}</td>
                                <td className="tableheadcol">{buy.itemname}</td>
                                <td className="tableheadcol">{buy.itemqty}</td>
                                <td className="tableheadcol">{buy.itemprice}</td>
                                <td className="text-center w-36">
                                    {buy?.itemaddress ? (
                                            <div>
                                                
                                                Resident No: {buy.itemaddress.residentno }
                                                Street: {buy.itemaddress.streetname }  
                                                Area: {buy.itemaddress.areaname } 
                                                City: {buy.itemaddress.city }
                                                Pin code :{buy.itemaddress.pincode}
                                                state : {buy.itemaddress.state}
                                                country:{buy.itemaddress.country}
                                                contact: {buy.itemaddress.contact}
                                                whatsapp: {buy.itemaddress.whatsapp}
                                                landmark: {buy.itemaddress.landmark}
                                                Latitude:{buy.itemaddress.lat}
                                                Longitude:{buy.itemaddress.longi}
                                            </div>
                                        ) : (
                                            <div>No address found</div>
                                        )}
                                    </td>
                                <td className={`text-center ${buy.itemstatus === "pending" ? 'text-red-600' : 'text-green-600'}`}>{buy.itemstatus}</td>
                                <td className="tableheadcol">{buy.itemcategory}</td>
                                <td className="tableheadcol">{buy.personnumber}</td>
                                <td className="tableheadcol">{buy.itemassinged}</td>
                                
                                <td className="items-center flex justify-center  space-x-4 p-4">
                                    <select className="bg-gray-600 p-3 w-44 text-white rounded focus:ring-2 focus:ring-gray-500 focus:outline-none hover:bg-black transition duration-300" value={selectedValues[buy._id] || ""} onChange={(e) => handleSelectChange(buy._id, e.target.value)}>
                                        <option value = "">Choose To Assign</option>
                                        {
                                            assign.map(asg => (
                                                <option key={asg._id} value={asg.otusername}>{asg.otusername}</option>
                                            ))
                                        }
                                    </select>

                                    <button className="bg-white px-5 text-center py-3 w-28 rounded text-black border-gray-400 border-2 hover:bg-black hover:text-white transition duration-300" onClick={() => handleSubmit(buy._id)}>Assign</button>
                                </td>
                                <td className="tableheadcol">
                                   {
                                    <select className="bg-gray-600 p-3 w-44 text-white rounded focus:ring-2 focus:ring-gray-500 focus:outline-none hover:bg-black transition duration-300" value={status} onChange={(e) => sttatus(buy._id, e.target.value) } >
                                        <option value="">Change status</option>
                                        <option value="pending">Pending</option>
                                        <option value="complete">Complete</option>
                                        <option value="canceled">Cancel</option>
                                    </select>
                                   }
                                </td>
                                
                                <td className="w-16 text-center " >{ <button className="updateview" onClick={() => targetview(buy) }>
                                <svg fill="white" width="25px" height="25px" viewBox="-3.5 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
                                    <title>view</title>
                                    <path d="M12.406 13.844c1.188 0 2.156 0.969 2.156 2.156s-0.969 2.125-2.156 2.125-2.125-0.938-2.125-2.125 0.938-2.156 2.125-2.156zM12.406 8.531c7.063 0 12.156 6.625 12.156 6.625 0.344 0.438 0.344 1.219 0 1.656 0 0-5.094 6.625-12.156 6.625s-12.156-6.625-12.156-6.625c-0.344-0.438-0.344-1.219 0-1.656 0 0 5.094-6.625 12.156-6.625zM12.406 21.344c2.938 0 5.344-2.406 5.344-5.344s-2.406-5.344-5.344-5.344-5.344 2.406-5.344 5.344 2.406 5.344 5.344 5.344z"></path>
                                </svg>
                                </button> }</td>
                                
                                <td className="w-16 text-center "><button  className="rowdel" onClick={() => deletemodel(buy._id)}>
                                    <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M3 6.38597C3 5.90152 3.34538 5.50879 3.77143 5.50879L6.43567 5.50832C6.96502 5.49306 7.43202 5.11033 7.61214 4.54412C7.61688 4.52923 7.62232 4.51087 7.64185 4.44424L7.75665 4.05256C7.8269 3.81241 7.8881 3.60318 7.97375 3.41617C8.31209 2.67736 8.93808 2.16432 9.66147 2.03297C9.84457 1.99972 10.0385 1.99986 10.2611 2.00002H13.7391C13.9617 1.99986 14.1556 1.99972 14.3387 2.03297C15.0621 2.16432 15.6881 2.67736 16.0264 3.41617C16.1121 3.60318 16.1733 3.81241 16.2435 4.05256L16.3583 4.44424C16.3778 4.51087 16.3833 4.52923 16.388 4.54412C16.5682 5.11033 17.1278 5.49353 17.6571 5.50879H20.2286C20.6546 5.50879 21 5.90152 21 6.38597C21 6.87043 20.6546 7.26316 20.2286 7.26316H3.77143C3.34538 7.26316 3 6.87043 3 6.38597Z" fill="white"/>
                                        <path fill-rule="evenodd" clip-rule="evenodd" d="M11.5956 22.0001H12.4044C15.1871 22.0001 16.5785 22.0001 17.4831 21.1142C18.3878 20.2283 18.4803 18.7751 18.6654 15.8686L18.9321 11.6807C19.0326 10.1037 19.0828 9.31524 18.6289 8.81558C18.1751 8.31592 17.4087 8.31592 15.876 8.31592H8.12404C6.59127 8.31592 5.82488 8.31592 5.37105 8.81558C4.91722 9.31524 4.96744 10.1037 5.06788 11.6807L5.33459 15.8686C5.5197 18.7751 5.61225 20.2283 6.51689 21.1142C7.42153 22.0001 8.81289 22.0001 11.5956 22.0001ZM10.2463 12.1886C10.2051 11.7548 9.83753 11.4382 9.42537 11.4816C9.01321 11.525 8.71251 11.9119 8.75372 12.3457L9.25372 17.6089C9.29494 18.0427 9.66247 18.3593 10.0746 18.3159C10.4868 18.2725 10.7875 17.8856 10.7463 17.4518L10.2463 12.1886ZM14.5746 11.4816C14.9868 11.525 15.2875 11.9119 15.2463 12.3457L14.7463 17.6089C14.7051 18.0427 14.3375 18.3593 13.9254 18.3159C13.5132 18.2725 13.2125 17.8856 13.2537 17.4518L13.7537 12.1886C13.7949 11.7548 14.1625 11.4382 14.5746 11.4816Z" fill="white"/>
                                    </svg>
                                    </button>
                                </td>
                            </tr>
                        ))
                    }
                    {
                        
                        box && viewcart.cartdetails && (
                            <div>
                                <button onClick={cancel}>Clear</button>
                                {
                                    viewcart.cartdetails.map((address, index) => (
                                        <div key={index}>
                                            <h3>Item name:</h3> {address.itemname}<br/>
                                            <h3>Total price:</h3> <span>{address.itemorip}</span><br/>
                                            <h3>Offer price:</h3> <span>{address.itemoffpr}</span><br/>
                                            <h3>No. pieces:</h3> <span>{address.itempice}</span><br/>
                                            <h3>Category:</h3> <span>{address.itemcategory}</span><br/>
                                            <h3>Qty:</h3> <span>{address.qty}</span><br/>
                                            <h3>Original Price:</h3> <span>{address.itemorip2}</span>
                                        </div>
                                    ))
                                }
                            </div>
                            
                        )
                        
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


            <Modal show={showmodel} className="w-1/3  mx-auto ">
                <div className="innermodal">
                <Modal.Header className="flex justify-center"><HiOutlineExclamationCircle className="modalicon" /></Modal.Header>
                <Modal.Body className="modaldel">
                    Are you sure want to delete?
                </Modal.Body>
                <Modal.Footer className="modalfooter">
                
                <Button className="cancelmodal " onClick={(cancel)}>Wait..wait..</Button>
                <Button className="addmodal" onClick={()=> deletebuy(deleteid)}>Yes.. Do it</Button>
                </Modal.Footer>
                </div>
            </Modal>
            
            
            
        </div>
       

        
    )

}

export default Buy;