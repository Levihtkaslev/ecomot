const perdetails = require("../Collection/persdetail");

exports.postprofile = async(req, res) => {
        const {
            cusname, 
            cusgender,
            cusphonenumber,
            cuspin,
            cusaddress,
            cuscity,
            cuslandmark,
            cusstate,
            cuslati,
            cuslong
        } = req.body;
    
        try {
            const createpro = new perdetails({  cusname, 
                                                cusgender,
                                                cusphonenumber,
                                                cuspin,
                                                cusaddress,
                                                cuscity,
                                                cuslandmark,
                                                cusstate,
                                                cuslati,
                                                cuslong
                                            })
                                            await createpro.save();
                                            res.status(201).json({
                                                message : "Profile Created successfully",
                                                createpro
                                            })
        } catch (error) {
           res.status(500).json({ message: error });
        }
}

exports.getprofile = async(req, res) => {
    try {
           const getprofile = await perdetails.find();
           res.status(200).json(
             getprofile
           )
        } catch (error) {
            console.log("Error during fetching profile : ",error);
        }
}

exports.updateprofile = async(req, res) => {
        const id = req.params.id;
        const {cusname, 
               cusgender,
               cusphonenumber,
               cuspin,
               cusaddress,
               cuscity,
               cuslandmark,
               cusstate,
               cuslati,
               cuslong
            } = req.body;
        
        try {
            const updateprofile = await perdetails.findByIdAndUpdate(id, {cusname, 
                cusgender,
                cusphonenumber,
                cuspin,
                cusaddress,
                cuscity,
                cuslandmark,
                cusstate,
                cuslati,
                cuslong}, {new : true} );
            await updateprofile.save();
            res.json({
                message : "Updated successfully",
                updateprofile
            })
        } catch (error) {
            console.log("Error while updating :",error);
        }
}

exports.deleteprofile = async(req, res) => {
    const id = req.params.id;
        try {
            await perdetails.findByIdAndDelete(id);
            res.json({
                message : "Profile deleted successfully",
            })
        } catch (error) {
            console.log("Error while deleing profile : ",error)
        }
}