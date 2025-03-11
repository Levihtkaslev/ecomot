const express = require("express");
const router = express.Router();
const { postcart, getcart, updatecart, deletecart, clearcart } = require("../destination/cart");

router.post('/cart', postcart);
router.get('/cart/:userid', getcart);
router.put('/cart/qty_increase', updatecart);
router.delete('/cart', deletecart);
router.post('/cart/clear', clearcart);

module.exports = router;
