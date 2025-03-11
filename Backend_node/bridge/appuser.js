const express = require("express");
const { postuser, getuser, updateuser, deleteuser, loginappuser,forgetapppass } = require("../destination/appuser");
const router = express.Router();

router.post('/user', postuser);
router.get('/user', getuser);
router.put('/user/:id', updateuser);
router.delete('/user/:id', deleteuser);
router.post('/loging', loginappuser);
router.post('/forgetpass', forgetapppass)

module.exports = router;
