const mongoose = require("mongoose");

const otitem = new mongoose.Schema({
    itemname  : { type : String},
    itemimage : {type : String},
    itemdescr : {type : String,},
    itemfor : {type : String, },
    itemtopnut : {type : String, },
    itemorip  : {type : Number, required : true},
    itemorip2  : {type : Number, required : true, default: function() {return this.itemorip;}},
    itemoffpr : {type : Number, required : true},
    itempice  : {type : String, required : true},
    itemtotalprice : {type : Number, required : true},
    itemcategory : {type : String, required : true},
    qty : {type : Number, required : true},
    maxqty : {type : Number, required : true},
    status : {type : String, default: "inactive"}
});

module.exports = mongoose.model("otitem", otitem);