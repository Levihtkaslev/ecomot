const mongoose = require("mongoose");

const corimage = new mongoose.Schema({
    imagename : String,
    image : String,
    imagetype : String
});

module.exports = mongoose.model("corimage", corimage);