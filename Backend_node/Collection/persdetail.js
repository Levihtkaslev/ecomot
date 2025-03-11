const mongoose = require("mongoose");

const perdetails = new mongoose.Schema({
    cusname : { type : String, required : true },
    cusgender : {type : String},
    cusphonenumber : { type : String, required : true},
    cuspin : { type : String },
    cusaddress : { type : String },
    cuscity : { type : String, required : true },
    cuslandmark : { type : String},
    cusstate : { type : String },
    cuslati : { type : String},
    cuslong : { type : String}
})

module.exports = mongoose.model("perdetais", perdetails);