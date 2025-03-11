const express = require("express");
const { postoldotuser, getoldotuser, updateoldotuser, deleteoldotuser } = require("../destination/oldotuser");
const router = express.Router();

router.post('/otuser', postoldotuser);
router.get('/otuser', getoldotuser);
router.put('/otuser/:id', updateoldotuser);
router.delete('/otuser/:id', deleteoldotuser);

module.exports = router;