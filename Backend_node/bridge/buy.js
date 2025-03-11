const express = require("express");
const { postbuy, getbuy, deletebuy, updateassign } = require("../destination/buy");
const router = express.Router();

router.post("/buy", postbuy);
router.get('/buy', getbuy);
router.delete('/buy/:id', deletebuy);
router.patch('/updateassignee/:id', updateassign);

module.exports = router;