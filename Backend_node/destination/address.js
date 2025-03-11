const address = require("../Collection/address");

exports.postaddress = async(req, res) => {
    const {userid, useraddress} = req.body;
    
        try {
            let user = await address.findOne({userid});
    
            if(!user){
                user = new address({ userid, useraddress : [useraddress]})
            }else{
                user.useraddress.push(useraddress);
            }
    
            await user.save();
            res.status(201).json({ message: "Address added successfully", user });
        } catch (error) {
            console.log("error :", error)
        }
}

exports.getaddress = async(req, res) => {
     const { userid } = req.params;
    
        try {
            
            const getaddress = await address.findOne({userid});
    
            if(!getaddress || getaddress.useraddress.length === 0){
                return res.status(404).json({ message: "No addresses found" });
            }
            res.status(200).json(getaddress);
        } catch (error) {
            console.log("Error :", error)
        }
}

exports.updateaddress = async(req, res) => {
    const { userid, addressid } = req.params;
        const updatedaddress = req.body;
    
        try {
            
            const getuser = await address.findOne({userid});
    
            if(!getuser){
                return res.status(404).console.log("User not found");
            }
    
            const particularuser = getuser.useraddress.findIndex((userad) => userad._id.toString() === addressid);
    
            if (particularuser === -1) {
                return res.status(404).json({ message: "Address not found" });
            }
    
            getuser.useraddress[particularuser] = {...getuser.useraddress[particularuser].toObject(), ...updatedaddress};
            await getuser.save();
    
            res.status(200).json({
                message: "Address updated successfully",
                updatedaddress : getuser.useraddress[particularuser]
            })
        } catch (error) {
            console.log("Error :", error)
        }
}

exports.deleteaddress = async(req, res) => {
      try{
                const { userid, addressid } = req.params;
        
                const user = await address.findOne({ userid });
                if (!user) {
                    return res.status(404).json({ message: "User not found" });
                }
                user.useraddress = user.useraddress.filter(address => address._id.toString() !== addressid);
                await user.save();
                res.status(200).json({ message: "Address deleted successfully", user });
            }catch(err){
                res.status(500).json({ message: "Error deleting address", err });
            }
}
