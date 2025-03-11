const cartee = require("../Collection/cart");
const otitem = require("../Collection/item");
const mongoose = require('mongoose');

exports.postcart = async(req, res) => {
      const { userid, itemid, qty } = req.body;
      
        try {
          
          let cart = await cartee.findOne({ userid });
      
          if (!cart) {
            cart = new cartee({ userid, items: [] });
          }
      
          const exist = cart.items.find((item) => item.itemid.toString() === itemid);
      
          if (exist) {
            return res.json({ message: "Item already in the cart" });
          } else {
            const item = await otitem.findById(new mongoose.Types.ObjectId(itemid)); 
            if (!item) {
              return res.status(404).json({ message: "Item not found" });
            }
      
            // Add the new item to the cart🐟
            cart.items.push({
              itemid,
              itemname: item.itemname,
              itemimage: item.itemimage,
              itemdescr: item.itemdescr,
              itemorip: item.itemorip,
              itemoffpr: item.itemoffpr,
              itempice: item.itempice,
              itemtotalprice : item.itemtotalprice,
              itemcategory: item.itemcategory,
              maxqty : item.maxqty,
              itemorip2 : item.itemorip2,
              itemdescr : item.itemdescr,
              itemfor : item.itemfor,
              qty
            });
      
            // Save the updated cart
            await cart.save();
      
            return res.status(200).json({
              message: "Item added successfully",
              cart
            });
          }
        } catch (error) {
          console.error("Item added successfully is unsuccessful:", error.message);
          return res.status(500).json({ message: "Internal Server Error" });
        }
}

exports.getcart = async(req, res) => {
    const userid = req.params.userid;
        console.log(userid)
    
        try {
            const usercart = await cartee.findOne({userid})
            
            if(!usercart){
                return res.status(200).json({
                    message : "Cart is empty"
                })
            }
    
            res.status(200).json({
                usercart
            })
        } catch (error) {
            res.status(500).json({
                message : "Error while fetch cart ",
             })
            console.log("err", error.message)
        }
}

exports.updatecart = async(req, res) => {
        const {userid, itemid, qty} = req.body;
    
        try {
            
            let cart = await cartee.findOne({userid});
            if (!cart) {
                return res.status(404).json({ message: "cart not found" });
              }
            
              const itemee =  cart.items.find(item => item.itemid === itemid);
           
    
            if(itemee){
    
                const oneunitprice = parseInt(itemee.itemorip);
                const totalprice = (oneunitprice*qty);
                // itemee.qty = parseFloat(qty);
                itemee.itemtotalprice = parseInt(totalprice);
               
                await cart.save();
                console.log(itemee)
                res.json({
                    message : "Item quantity update successfully",
                    cart
                })
            }else {
                
                return res.status(404).json({ message: "Item not found in cart" });
              }
    
        } catch (error) {
            console.log("Error while increasing qty count : ",error);
        }
}

exports.deletecart = async(req, res) => {
    try {
            const { userid, itemid } = req.body;
    
            const updatedCart = await cartee.findOneAndUpdate(
                { userid: userid },  
                { $pull: { items: {itemid :itemid} } },
                { new: true }
            );
    
            if (!updatedCart) {
                return res.status(404).json({ message: 'Cart not found for this user' });
            }
    
            res.json({ message: 'Item removed successfully', cart: updatedCart });
    
        } catch (error) {
            console.error('Error:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        }
}

exports.clearcart = async(req,res) => {
      try {
            const { userid } = req.body;
    
            const updatedCart = await cartee.findOneAndUpdate(
                { userid: userid },
                { $set: { items: [] } }, 
                { new: true }
            );
    
            if (!updatedCart) {
                return res.status(404).json({ message: 'Cart not found' });
            }
    
            res.json({ message: 'Cart cleared successfully', cart: updatedCart });
        } catch (error) {
            console.error('Error:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        }
}