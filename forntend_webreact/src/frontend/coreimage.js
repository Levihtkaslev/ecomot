import React, {useState, useEffect} from "react";
import { toast } from "react-toastify";
import { HiOutlineExclamationCircle } from "react-icons/hi";
import { Button, Modal } from "flowbite-react";

const Coreimage = () => {

    const [imagelist, setimagelist] = useState([]);
    const [imagename, setimagename] = useState("");
    const [image, setimage] = useState('');
    const [imagetype, setimagetype] = useState('');
    const [currentPage, setCurrentPage] = useState(1);
    const [rowsPerPage, setRowsPerPage] = useState(10);
    const[deleteid, setdeleteid] = useState('');
    const[showdelmodel, setshowdelmodel] = useState(false);
    
    const totalPages = Math.ceil(imagelist.length / rowsPerPage);
    const backendbaseurl = process.env.REACT_APP_NODE_BACKEND_BASEURL

    useEffect(() => {
        getimage();
    },[])


    const getimage = async() => {
        const response = await fetch(`${backendbaseurl}/ad`);
        const res = await response.json();
        setimagelist(res.reverse());  
    }


    const createitem = async () => {

        const formdata = new FormData();
        formdata.append("imagename", imagename);
        formdata.append("image", image); 
        formdata.append("imagetype", imagetype);

        await fetch(`${backendbaseurl}/ad`,{
            method : "POST",
            body : formdata, 
        });
        getimage();
        cancel();
        toast.success("Banner Added Successfully")
    }

    const deleteitem = async (e) => {
        await fetch(`${backendbaseurl}/ad/${e}`,{
            method : "DELETE",
           });
        getimage();
        toast.success("Banner Deleted Successfully")
        setshowdelmodel(false)
    };

    const handlefile = (e) => {

        const file = e.target.files[0];
        if (file) {
            setimage(file);
        }
    }

    const cancel = () => {
        setimagename("")
        setimagetype("")
        setimage("")
        setshowdelmodel(false)
    }

    const indexOfLastRow = currentPage * rowsPerPage;
    const indexOfFirstRow = indexOfLastRow - rowsPerPage;
    const currentRows = imagelist.slice(indexOfFirstRow, indexOfLastRow);

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

    return (
        <div>
            <div className="header">
                <h3 className="text-white text-3xl">Item</h3>
            </div>

            <div className="secheader">
                
            <div className="flex gap-8 justify-between items-center">
                <select className="select" id="rowsPerPage" value={rowsPerPage} onChange={handleRowsPerPageChange}>
                    <option className="selectinner" value="10">10 Rows</option>
                    <option className="selectinner" value="20">20 Rows</option>
                    <option className="selectinner" value="50">50 Rows</option>
                </select>
                <div className="searchout">
                    <input  className="searchinner" value={imagename} onChange={(e) => setimagename(e.target.value)} placeholder="imagename"/>
                    
                </div>
                <input className="cursor-pointer"  type="file" onChange={handlefile} />
                <select  className="select"  value={imagetype} onChange={(e) => setimagetype(e.target.value)}>
                    <option className="selectinner" value = "">Type</option>
                    <option className="selectinner" value = "core">Core</option>
                    <option className="selectinner" value = "review">Review</option>
                </select>
                <button className="addbut" onClick={createitem}>
                    Add
                        <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22ZM12.75 9C12.75 8.58579 12.4142 8.25 12 8.25C11.5858 8.25 11.25 8.58579 11.25 9L11.25 11.25H9C8.58579 11.25 8.25 11.5858 8.25 12C8.25 12.4142 8.58579 12.75 9 12.75H11.25V15C11.25 15.4142 11.5858 15.75 12 15.75C12.4142 15.75 12.75 15.4142 12.75 15L12.75 12.75H15C15.4142 12.75 15.75 12.4142 15.75 12C15.75 11.5858 15.4142 11.25 15 11.25H12.75V9Z" fill="white"/>
                        </svg>
                </button>
                <button className="clearbut" onClick={cancel}>
                    Cancel
                    <svg fill="white" width="25px" height="25px" viewBox="0 0 56 56" xmlns="http://www.w3.org/2000/svg">
                        <path d="M 13.7851 49.5742 L 42.2382 49.5742 C 47.1366 49.5742 49.5743 47.1367 49.5743 42.3086 L 49.5743 13.6914 C 49.5743 8.8633 47.1366 6.4258 42.2382 6.4258 L 13.7851 6.4258 C 8.9101 6.4258 6.4257 8.8398 6.4257 13.6914 L 6.4257 42.3086 C 6.4257 47.1602 8.9101 49.5742 13.7851 49.5742 Z M 19.6913 38.3711 C 18.5429 38.3711 17.5820 37.4336 17.5820 36.2852 C 17.5820 35.7461 17.8163 35.2305 18.2382 34.8086 L 25.0351 27.9649 L 18.2382 21.1445 C 17.8163 20.7227 17.5820 20.2071 17.5820 19.6680 C 17.5820 18.4961 18.5429 17.5352 19.6913 17.5352 C 20.2539 17.5352 20.7460 17.7461 21.1679 18.1680 L 28.0117 25.0118 L 34.8554 18.1680 C 35.2539 17.7461 35.7695 17.5352 36.3085 17.5352 C 37.4804 17.5352 38.4413 18.4961 38.4413 19.6680 C 38.4413 20.2071 38.2070 20.7227 37.7851 21.1445 L 30.9648 27.9649 L 37.7851 34.8086 C 38.2070 35.2305 38.4413 35.7461 38.4413 36.2852 C 38.4413 37.4336 37.4804 38.3711 36.3085 38.3711 C 35.7695 38.3711 35.2539 38.1602 34.8788 37.7852 L 28.0117 30.8945 L 21.1444 37.7852 C 20.7460 38.1602 20.2773 38.3711 19.6913 38.3711 Z"/>
                    </svg>
                </button>
                </div>
            </div>
            <div className="table1">
            <table className="tableout">
                <thead className="tablebgcolor">
                    <tr className="py-14  h-16">
                        <th className="tableheadcol" >S.no</th>
                        <th className="tableheadcol" >Image Name</th>
                        <th className="tableheadcol" >Image</th>
                        <th className="tableheadcol" >Type</th>
                        <th className="tableheadcol" >Action</th>
                    </tr>
                </thead>
                <tbody>
                    {
                        currentRows.length === 0 ? (
                            <tr>
                                <td className="tableheadcol" colSpan="11" style={{ textAlign: 'center' }}>No items found</td>
                            </tr>): (
                            currentRows.map((item, index) => (
                                <tr className={`py-14 h-20  ${index % 2 === 0 ? 'bg-white': 'bg-gray-100'} hover:bg-gray-200 `}>
                                    <td className="tableheadcol" >{index + 1}</td>
                                    <td className="tableheadcol" >{item.imagename}</td>
                                    <td className="tableheadcol" ><a href={item.image}  target="_blank" rel="noopener noreferrer">
                                        <img src={item.image} alt="Preview"  style={{ borderRadius:'50px', width:"40px", height:"40px"}} /></a>
                                    </td>
                                    <td className="tableheadcol" >{item.imagetype}</td>
                                <td className="tableheadcol"> 
                                    <button className="rowdel" onClick={() => deletemodel(item._id)}>
                                        <svg width="25px" height="25px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M3 6.38597C3 5.90152 3.34538 5.50879 3.77143 5.50879L6.43567 5.50832C6.96502 5.49306 7.43202 5.11033 7.61214 4.54412C7.61688 4.52923 7.62232 4.51087 7.64185 4.44424L7.75665 4.05256C7.8269 3.81241 7.8881 3.60318 7.97375 3.41617C8.31209 2.67736 8.93808 2.16432 9.66147 2.03297C9.84457 1.99972 10.0385 1.99986 10.2611 2.00002H13.7391C13.9617 1.99986 14.1556 1.99972 14.3387 2.03297C15.0621 2.16432 15.6881 2.67736 16.0264 3.41617C16.1121 3.60318 16.1733 3.81241 16.2435 4.05256L16.3583 4.44424C16.3778 4.51087 16.3833 4.52923 16.388 4.54412C16.5682 5.11033 17.1278 5.49353 17.6571 5.50879H20.2286C20.6546 5.50879 21 5.90152 21 6.38597C21 6.87043 20.6546 7.26316 20.2286 7.26316H3.77143C3.34538 7.26316 3 6.87043 3 6.38597Z" fill="white"/>
                                            <path fill-rule="evenodd" clip-rule="evenodd" d="M11.5956 22.0001H12.4044C15.1871 22.0001 16.5785 22.0001 17.4831 21.1142C18.3878 20.2283 18.4803 18.7751 18.6654 15.8686L18.9321 11.6807C19.0326 10.1037 19.0828 9.31524 18.6289 8.81558C18.1751 8.31592 17.4087 8.31592 15.876 8.31592H8.12404C6.59127 8.31592 5.82488 8.31592 5.37105 8.81558C4.91722 9.31524 4.96744 10.1037 5.06788 11.6807L5.33459 15.8686C5.5197 18.7751 5.61225 20.2283 6.51689 21.1142C7.42153 22.0001 8.81289 22.0001 11.5956 22.0001ZM10.2463 12.1886C10.2051 11.7548 9.83753 11.4382 9.42537 11.4816C9.01321 11.525 8.71251 11.9119 8.75372 12.3457L9.25372 17.6089C9.29494 18.0427 9.66247 18.3593 10.0746 18.3159C10.4868 18.2725 10.7875 17.8856 10.7463 17.4518L10.2463 12.1886ZM14.5746 11.4816C14.9868 11.525 15.2875 11.9119 15.2463 12.3457L14.7463 17.6089C14.7051 18.0427 14.3375 18.3593 13.9254 18.3159C13.5132 18.2725 13.2125 17.8856 13.2537 17.4518L13.7537 12.1886C13.7949 11.7548 14.1625 11.4382 14.5746 11.4816Z" fill="white"/>
                                        </svg>
                                    </button>
                                </td>
                                </tr>
                            ))
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

            <Modal show={showdelmodel} className="w-1/3  mx-auto ">
                <div className="innermodal">
                <Modal.Header className="flex justify-center"><HiOutlineExclamationCircle className="modalicon" /></Modal.Header>
                <Modal.Body className="modaldel">
                    Are you sure want to delete?
                </Modal.Body>
                <Modal.Footer className="modalfooter">
                
                <Button className="cancelmodal " onClick={(cancel)}>Wait..wait..</Button>
                <Button className="addmodal" onClick={()=> deleteitem(deleteid)}>Yes.. Do it</Button>
                </Modal.Footer>
                </div>
            </Modal>
        </div>
        
    )


}

export default Coreimage;