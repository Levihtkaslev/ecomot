const category = require("../Collection/category");

exports.postcat = async(req, res) => {
    const {categname} = req.body;
    
        try {
            const createcateg = await category({categname});
            await createcateg.save();
            res.json({
                message : "Category Created successfully",
                createcateg
            })
        } catch (error) {
            console.log("Error while Creating category", error)
        }
}

exports.getcatid = async(req, res) => {
    const{id} = req.params;
    
        try {
            if(id){
                const getcateg = await category.findById({_id : id});
                if(!getcateg){
                    return res.json({
                        message : "Category Not found"
                    })
                }
                return res.status(200).json(getcateg);
            }
        } catch (error) {
            console.log("Error while fetching category : ", error)
        }
}

exports.getcat = async(req, res) => {
     try {
          const getcat = await category.find({});
          res.status(200).json(getcat);
        } catch (error) {
          console.log("Error during fetching items: ", error);
          res.status(500).json({ error: "Internal Server Error" });
        }
}

exports.updatecat = async(req, res) => {
     const {id} = req.params;
        const { categname } = req.body;
      
        try {
         
          const updatecat = await category.findByIdAndUpdate(
           { _id : id}, { categname },  { new: true } 
          );
      
          if (!updatecat) {
            return res.status(404).json({ message: "Category not found" });
          }
      
          res.json({
            message: "Category Updated successfully",
            updatecat
          });
        } catch (error) {
          console.error("Error while updating category:", error);
          res.status(500).json({ message: "Internal server error" });
        }
}

exports.deletecat = async(req, res) => {
       const {id} = req.params;
        try {
            await category.findByIdAndDelete({_id : id});
            res.json({
                message : "Category deleted successfully",
            })
        } catch (error) {
            console.log("Error while deleting :", error)
        }
}