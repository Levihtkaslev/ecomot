const mongoose = require("mongoose");

const address = new mongoose.Schema({
    userid : {type : String, require : true},
    useraddress : [
        {
            userid      : {type : String, require : true},
            streetname  : {type : String, require : true},
            residentno  : {type : String, require : true},
            areaname    : {type : String, require : true},
            city        : {type : String, require : true},
            pincode     : {type : String, require : true},
            state       : {type : String},
            country     : {type : String},
            contact     : {type : String, require : true},
            landmark    : {type : String, require : true},
            whatsapp    : {type : String},
            lat         : {type : String},
            longi       : {type : String},
        }
    ]
})

module.exports = mongoose.model("address", address);