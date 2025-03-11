const mongoose = require("mongoose");

const otuser = new mongoose.Schema({
    otusername : String,
    otuserrole : String,
    otuserid : String,
    otuserpass : String
});

module.exports = mongoose.model("otuser", otuser);