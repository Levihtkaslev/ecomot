const mongoose = require("mongoose");

const category = new mongoose.Schema({
    categname : { type : String,  required : true }
});

module.exports = mongoose.model("category", category);