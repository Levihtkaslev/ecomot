const express = require("express");
const app = express();
const mongoose = require("mongoose");
const cors = require("cors");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const dotenv = require('dotenv');
const bodyParser = require('body-parser');


dotenv.config({path: path.join(__dirname, 'configuration', 'config.env')})

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
const port = 2001;
app.listen(port, () => {
    console.log("Connected to the port", port)
});


//============================================================Collection Area======================================================================================================================================================

const otitem = require("./Collection/item");
const admin = require("./Collection/firbase");
const corimage = require("./Collection/image");


//==============================================================Segregated======================================================================================================================================================

const usero = require('./bridge/appuser');
const profileo = require('./bridge/profile');
const carteeo = require('./bridge/cart')
const categ = require('./bridge/category')
const oldotuser = require('./bridge/oldotuser');
const buyo = require('./bridge/buy');
const addresso = require('./bridge/address');


mongoose.connect("mongodb://localhost:27017/ot").then(() => {console.log("Mongodb connected Successfully")}).catch((err) => {console.log("Errore : ",err)});



//================================================================Image related=======================================================================================================================================

app.use("/ot/baseone/uploads", express.static(path.join(__dirname, "uploads")));

const storage = multer.diskStorage({
    destination : (req, file, cb) => {
        cb(null, "uploads/");
    },
    filename : (req, file, cb) => {
        const uniquename = Date.now() + path.extname(file.originalname);
        cb(null, file.fieldname + "-" + uniquename); 
    }
});

const filefilter = (req, file, cb) => {
    const allowed = ["image/jpeg", "image/png", "application/pdf"];
    if (allowed.includes(file.mimetype)) {
        cb(null, true); 
      } else {
        cb(new Error("Invalid file type. Only JPEG, PNG, and PDF are allowed."), false); 
      }
};

const upload = multer({
    storage: storage,
    fileFilter: filefilter,
    limits: { fileSize: 2 * 1024 * 1024 }, 
  });



//******************************************************************API Area****************************************************************

//Segregated
app.use('/ot/baseone',usero);
app.use('/ot/baseone',profileo);
app.use('/ot/baseone',carteeo);
app.use('/ot/baseone',categ);
app.use('/ot/baseone',oldotuser);
app.use('/ot/baseone',buyo);
app.use('/ot/baseone',addresso);



//Raw Apis

//===================================================================Item Apis====================================================================================================================================================

app.post("/ot/baseone/item", upload.single("itemimage"), async(req, res) => {
    const {itemname ,
           itemdescr,
           itemorip ,
           itemoffpr,
           itempice,
           itemtotalprice,
           qty,
           itemcategory,
           maxqty,
           itemfor,
           itemtopnut,
           status } =req.body;
    
    if (!req.file) {
        return res.status(400).json({ message: "Image file is required!" });
    }
    
        try {
            
            const createitem = new otitem({itemname ,
                                            itemimage : req.file.filename,
                                            itemdescr,
                                            itemorip ,
                                            itemoffpr,
                                            itempice,
                                            itemtotalprice,
                                            qty,
                                            itemcategory,
                                            itemtopnut,
                                            maxqty,
                                            itemfor,
                                            status});
            await createitem.save();
            res.json({
                message : "Successfully created",
                createitem
            })
        } catch (error) {
            console.log("Error creating items",error)
        }
});


  
  app.get("/ot/baseone/item", async (req, res) => {
    try {
      const getitem = await otitem.find({})
      const itemsWithImageUrl = getitem.map(item => ({
        ...item._doc,
        itemimage: item.itemimage ? `http://192.168.3.168:2001/ot/baseone/uploads/${item.itemimage}` : null,
      }));

      res.status(200).json(itemsWithImageUrl);
    } catch (error) {
      console.log("Error during fetching items: ", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  });
  


  
  app.put("/ot/baseone/item/:id", upload.single("itemimage"), async (req, res) => {
      const id = req.params.id;
      const { removeimage, ...updatedata } = req.body;
  
      try {
          const item = await otitem.findById(id);
  
          if (!item) {
              return res.status(404).json({ error: "Item not found" });
          }
  
          // Normalize the image path to ensure relative paths are used
          const normalizePath = (imagePath) => {
              const baseUrl = "http://192.168.3.168:2001/ot/baseone";
              return imagePath.startsWith(baseUrl) ? imagePath.replace(baseUrl, "") : imagePath;
          };
  
          // Remove image if requested
          if (removeimage === "true" && item.itemimage) {
              const relativePath = normalizePath(item.itemimage); // Remove base URL if present
              const filePath = path.join(__dirname, "uploads", relativePath);
  
              if (fs.existsSync(filePath)) {
                  fs.unlinkSync(filePath);
              }
              updatedata.itemimage = null; // Remove image field
          }
  
          // Add new image if provided
          if (req.file) {
              if (item.itemimage) {
                  const oldRelativePath = normalizePath(item.itemimage); // Normalize old image path
                  const oldFilePath = path.join(__dirname, "uploads", oldRelativePath);
  
                  if (fs.existsSync(oldFilePath)) {
                      fs.unlinkSync(oldFilePath);
                  }
              }
              updatedata.itemimage = req.file.filename; // Save new filename
          }
  
          // Update item in the database
          const updatedItem = await otitem.findByIdAndUpdate(id, updatedata, { new: true });
          res.json(updatedItem); // Return updated item
  
      } catch (error) {
          console.error("Error while updating items:", error);
          res.status(500).json({ error: "Internal server error" });
      }
  });
  

app.delete("/ot/baseone/item/:id", async(req, res) => {

    const id = req.params.id;
    try {
        await otitem.findByIdAndDelete(id);
        res.json({
            message : "Item deleted successfully",
        })
    } catch (error) {
        console.log("Error while deleing Item : ",error)
    }
})




//============================================================Firebase===============================================================================================================================================================

app.get('/ot/baseone/fire-users', async(req, res) => {

    try {
        const listusers = await admin.auth().listUsers();
        const users = listusers.users.map((use) => ({
            uid: use.uid,
            email: use.email,
            displayName: use.displayName,
            phoneNumber: use.phoneNumber,
        }))
        res.status(200).json(
            users
        ); 
    } catch (error) {
        console.log("Error while fetching list", error)
    }
})




//============================================================Corosol=========================================================================================================================================================

app.post("/ot/baseone/ad", upload.single("image"),async(req, res) => {
    const { imagename, imagetype} = req.body;
    if(!req.file){
        return res.status(400).json({
            message : "Not found",
        })
    }

    try {
        const postimage  = await corimage({ imagename, image : req.file.filename, imagetype });
        await postimage.save();
        res.status(201).json({
            message : "Created successfully",
            postimage
        });
    } catch (error) {
        console.log(res.json({messaging : error}))
    }
})


app.get("/ot/baseone/ad", async (req, res) => {
    try {
       const getimage = await corimage.find({})
       const getimagewithlink = getimage.map(image => ({
        ...image._doc,
        image : image.image ? `http://192.168.3.168:2001/ot/baseone/uploads/${image.image}` : null,
       })) ;
       res.status(200).json(getimagewithlink); 
    } catch (error) {
        console.log("Error during fetching items: ", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
})

app.delete("/ot/baseone/ad/:id", async(req, res) => {

    const id = req.params.id;
    try {
        await corimage.findByIdAndDelete(id);
        res.json({
            message : "Item deleted successfully",
        })
    } catch (error) {
        console.log("Error while deleing Item : ",error)
    }
})

//==============================================================================X-X-X=================================================================================================================================================================================================================================================================
//======================================================================== X-X-X END X-X-X ===========================================================================================================================================================================================================================================================
//==============================================================================X-X-X=================================================================================================================================================================================================================================================================