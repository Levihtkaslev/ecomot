const express = require("express");
const { postprofile, getprofile, updateprofile, deleteprofile } = require("../destination/profile");
const router = express.Router();

router.post('/profile', postprofile);
router.get('/profile', getprofile);
router.put('/profile/:id', updateprofile);
router.delete('/profile/:id', deleteprofile);

module.exports = router;