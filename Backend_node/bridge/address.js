const express = require("express");
const { postaddress, getaddress, updateaddress, deleteaddress } = require("../destination/address");
const router = express.Router();

router.post('/address', postaddress);
router.get('/address/:userid', getaddress);
router.put('/address/:userid/:addressid', updateaddress);
router.delete('/address/:userid/:addressid', deleteaddress);

module.exports = router;