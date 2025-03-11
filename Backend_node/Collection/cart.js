const mongoose = require("mongoose");

const cartee = new mongoose.Schema({
    userid : { type : String, required : true},
    items : [
        {
            itemid : {
                type : String, required : true
            },
            itemname : {
                type : String, required : true
            },
            itemimage : {
                type : String, required : true
            },
            itemdescr : {
                type : String, required : true
            },
            itemorip : {
                type : Number, required : true
            },
            itemoffpr : {
                type : Number, required : true
            },
            itempice : {
                type : String, required : true
            },
            itemcategory : {
                type : String, required : true
            },
            qty : {
                type : Number, required : true
            },
            maxqty : {
                type : Number
            },
            itemtotalprice : {
                type : Number, required : true
            },
            itemorip2 : {
                type : Number, required : true
            },
           
        }
    ]
});

module.exports = mongoose.model("cartee", cartee)