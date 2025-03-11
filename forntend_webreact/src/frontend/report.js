import React, {useState, useEffect} from "react";
import * as XLSX from "xlsx";
import { toast } from "react-toastify";

const Otreport = () => {
    const [otbuylist, setotbuylist] = useState([]);
    const[assign, setassign] = useState([]);
    const[category, setcategory] = useState([]);
    const[assi, setassi] = useState("");
    const[cat, setcat] = useState("");
    const[sts, setsts] = useState("");
    const[otcopy, setotcopy] = useState([]);

    const backendbaseurl = process.env.REACT_APP_NODE_BACKEND_BASEURL

        useEffect(() => {
            getbuylist();
            getassing();
            getcategory();
            getbuylistcopy();
        },[assi, cat, sts]);

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

    const getbuylistcopy = async () => {
        const response = await fetch(`${backendbaseurl}/buy`);
        const res = await response.json();
        setotcopy(res);
    }



    const getbuylist = async () => {
        const response = await fetch(`${backendbaseurl}/buy`);
        const res = await response.json();

        const filter = res.filter(res => {
            const assigneefill = assi === "" || res.itemassinged === assi; 
            const catfill = cat === "" || res.itemcategory === cat;
            const stsfill = sts === "" || res.itemstatus === sts;
            return(assigneefill && catfill && stsfill)
        })
        setotbuylist(filter);
    }

    const exportt = () => {

        if (category.length === 0) {
            alert("No data to export!");
            return;
        }
    
        
        const exportdata = category.map((ot) => ({
            Category: ot.categname,
            Pending: otbuylist.filter((buy) => buy.itemcategory === ot.categname && buy.itemstatus === "pending").length,
            Complete: otbuylist.filter((buy) => buy.itemcategory === ot.categname && buy.itemstatus === "complete").length,
            Total: otbuylist.filter((buy) => buy.itemcategory === ot.categname).length,
        }));
    
        exportdata.unshift({
            Category: "Overall",
            Pending: otbuylist.filter((ot) => ot.itemstatus === "pending").length,
            Complete: otbuylist.filter((ot) => ot.itemstatus === "complete").length,
            Total: otbuylist.length,
        });
    
        
        const worksheet = XLSX.utils.json_to_sheet(exportdata);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "OT Report");
        XLSX.writeFile(workbook, "OT_Report.xlsx");
        toast.success("Document dowloaded Successfully")
    }

    const cancel = () => {
        setcat("");
        setassi("");
        setsts("");
        toast.error("Canceled")
    }

    const categorydata = category.map((ot) => ({
        categname: ot.categname,
        pending: otbuylist.filter((buy) => buy.itemcategory === ot.categname && buy.itemstatus === "pending").length,
        complete: otbuylist.filter((buy) => buy.itemcategory === ot.categname && buy.itemstatus === "complete").length,
    }));

    return (
        <div>
            <div className="header">
                <h3 className="text-white text-3xl">Report</h3>
            </div>

            <div className="secheader">
            <div className="flex w-1/2 justify-between">
                <select className="select"  value={assi} onChange={(e) => setassi(e.target.value)}>
                    <option className="selectinner" value = "">All Assignee</option>
                    {
                        assign.map(assign => (<option className="selectinner" value={assign.otusername} key={assign._id}>{assign.otusername}</option>))
                    }
                </select>
                <select className="select"  value={cat} onChange={(e) => setcat(e.target.value)}>
                    <option className="selectinner" value = "">All Category</option>
                    {
                        category.map(assign => (<option className="selectinner" value={assign.categname} key={assign._id}>{assign.categname}</option>))
                    }
                </select>
                <select className="select"  value={sts}  onChange={(e) => setsts(e.target.value)}>
                    <option className="selectinner" value = "">All Status</option>
                    <option className="selectinner" value = "pending">Pending</option>
                    <option className="selectinner" value = "complete">Complete</option>
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

            
            <table className="tableout">
                <thead className="tablebgcolor">
                    <tr className="py-14  h-16">
                        <th className="tableheadcol">Total Request</th>
                        <th className="tableheadcol">Pending</th>
                        <th className="tableheadcol">Complete</th>
                    </tr>
                </thead>
                <tbody>
                    <tr className="py-14  h-16" >
                        <td className="tableheadcol">{otcopy.length}</td>
                        <td className="tableheadcol">{otbuylist.filter((ot) => ot.itemstatus === "pending").length}</td>
                        <td className="tableheadcol">{otbuylist.filter((ot) => ot.itemstatus === "complete").length}</td>
                    </tr>
                </tbody>
            </table>
           <div className="mt-16 mb-7 text-2xl">
            <t2>Category Wise</t2>
           </div>
            <table className="tableout">
                <thead className="tablebgcolor">
                    <tr className="py-14  h-16">
                        <th className="tableheadcol">S.No</th>
                        <th className="tableheadcol">Category</th>
                        <th className="tableheadcol">Pending</th>
                        <th className="tableheadcol">Complete</th>
                        <th className="tableheadcol">Total</th>
                    </tr>
                </thead>
                <tbody>
                  {
                    categorydata.map((cat, index) => (
                       <tr className={`py-14 h-16  ${index % 2 === 0 ? 'bg-white': 'bg-gray-100'} hover:bg-gray-200 `} key={index}>
                            <td className="tableheadcol">{index+1}</td>
                            <td className="tableheadcol">{cat.categname}</td>
                            <td className="tableheadcol">{cat.pending}</td>
                            <td className="tableheadcol">{cat.complete}</td>
                            <td className="tableheadcol">{cat.pending + cat.complete}</td>
                        </tr>
                       
                    ))
                  }
                </tbody>
            </table>
        </div>
    )
}

export default Otreport;