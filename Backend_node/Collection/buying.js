const mongoose = require("mongoose");

const buySchema = new mongoose.Schema({
    personname :{type: String, required: true},
    personnumber: {type: String, required: true},
    itemname: { type: String, required: true },
    itemqty: { type: Number, required: true },
    itemprice: { type: Number, required: true },
    itemaddress: { type: Object },
    itemcategory: { type: String, required: true },
    itemstatus: { type: String, default : "pending"},
    itemassinged: { type: String,default : "not assingned" },
    itemtime: { type: Date, default: Date.now }, 
    cartdetails: { type: Array, required: true },
    dropdowndisabled: { type: Boolean, default: false },
},{ timestamps: true });

buySchema.methods.toJSON = function () {
    const formObject = this.toObject();
    
    
    if (formObject.itemtime instanceof Date) {
        formObject.itemtime = formObject.itemtime.toLocaleString('en-US', { timeZone: 'Asia/Kolkata' });
    }
    
    return formObject;
};


module.exports = mongoose.model("buy", buySchema);