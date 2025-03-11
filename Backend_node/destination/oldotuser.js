const otuser = require("../Collection/otuser");

exports.postoldotuser = async(req, res) => {
     const { otusername,otuserrole, otuserid, otuserpass} = req.body;
        try {
            
            const createuser = await otuser({otusername,otuserrole, otuserid, otuserpass});
            await createuser.save();
            res.json({
                message : "Successfully created",
                createuser
            })
        } catch (error) {
            console.log("Error while creating a use", error)
        }
}

exports.getoldotuser = async(req, res) => {
     try {
            
                const gettheuser = await otuser.find({});
                res.json(
                    
                    gettheuser
                )
            
        } catch (error) {
            console.log("Error while getting info", error)
        }
}

exports.updateoldotuser = async(req, res) => {
    const { id } = req.params; 
        const { otusername, otuserrole, otuserid, otuserpass } = req.body; 
        try {
            
            const updateuser = await otuser.findByIdAndUpdate(
                id, 
                { otusername, otuserrole, otuserid, otuserpass }, 
                { new: true }
            );
    
            if (!updateuser) {
                return res.status(404).json({ message: "User not found" });
            }
    
            res.json({
                message: "User updated successfully",
                updateuser, 
            });
        } catch (error) {
            console.error("Error while updating user:", error);
            res.status(500).json({ message: "Internal server error" });
        }
}

exports.deleteoldotuser = async(req, res) => {
    try {
        await otuser.findByIdAndDelete(req.params.id)
        res.json({
            message : "Successfully deleted"
        })
       } catch (error) {
        console.log("error while deleting",error)
       }
}