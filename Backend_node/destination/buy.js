const buy = require("../Collection/buying");

exports.postbuy = async(req, res) => {
    const { personname, personnumber, itemname, itemqty, itemprice, itemaddress, itemcategory, itemstatus, itemassinged, itemtime, cartdetails} = req.body;
        try {
            const buyitem = await buy({personname, personnumber, itemname, itemqty, itemprice, itemaddress, itemcategory, itemstatus, itemassinged, cartdetails, itemtime: new Date()})
            await buyitem.save();
            res.status(200).json({
                message : "SUccessfully created",
                buyitem
            })
        } catch (error) {
            console.log("Error while creating", error)
        }
}

exports.getbuy = async(req, res) => {
    try {
            const { userid } = req.query;
            console.log("Received UserID:", userid);
    
            let query = {};  
            if (userid) {
                query = { personnumber: userid };
            }
    
            const getbuy = await buy.find(query);
            res.json(getbuy);
    
        } catch (error) {
            console.error("Error while getting details:", error);
            res.status(500).json({ error: "Internal server error" });
        }
}

exports.deletebuy = async(req, res) => {
    try {
            await buy.findByIdAndDelete(req.params.id)
            res.json({
                message : "🐟 Deleted Successfully",
            })
        } catch (error) {
            console.log("error :",error)
        }
}

exports.updateassign = async(req, res) => {
    const { id } = req.params;
      const { itemassinged, itemstatus } = req.body;
    
      try {
        const updatedBuylist = await buy.findByIdAndUpdate(
          id,
          { itemassinged: itemassinged, itemstatus : itemstatus}, 
          { new: true } 
        );
    
        if (!updatedBuylist) {
          return res.status(404).send({ message: "Item not found" });
        }
    
        res.status(200).send(updatedBuylist);
      } catch (error) {
        console.error(error);
        res.status(500).send({ message: "Server error" });
      }
}