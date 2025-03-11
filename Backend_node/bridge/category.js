const express = require("express");
const router = express.Router();
const { postcat, getcatid, getcat, updatecat, deletecat } = require("../destination/category");

router.post('/web/category', postcat);
router.get('/web/category/:id', getcatid);
router.get('/web/category', getcat);
router.put('/web/category/:id', updatecat);
router.delete('/web/category/:id', deletecat);

module.exports = router;