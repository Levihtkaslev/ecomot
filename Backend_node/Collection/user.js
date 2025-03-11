const mongoose = require("mongoose");

const user = new mongoose.Schema({
    usernum : {type : String, required : true},
    pass : {type : String, required : true},
    mail : {type : String}
},{ timestamps: true });

module.exports = mongoose.model("user",user);