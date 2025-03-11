const bcrypt = require('bcrypt');
const user = require("../Collection/user");
const sendmail = require("../Collection/mail");


exports.postuser = async (req, res) => {
    const {usernum, pass, mail} = req.body;
    const existingUser = await user.findOne({ usernum });

        if (existingUser) {
            return res.status(400).json({ message: "Phone number already registered" });
        }
    
    const saltrange = 10;
    const salt = await bcrypt.genSalt(saltrange);
    const hashedpass = await bcrypt.hash(pass, salt);

    try {
        let createuser = new user({ usernum, pass : hashedpass, mail });
        await createuser.save();
        await sendmail(mail, usernum, pass);
        res.status(201).json({
            message : "Created successfully",
            createuser
        })
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
        console.log("Error while creating user :", error)
    }
}

exports.getuser = async (req, res) => {
      try {
            const getuser = await user.find();
            res.status(200).json(
                
                getuser
            )
        } catch (error) {
            console.log("Error while Fetching : ", error)
        }
}

exports.updateuser = async (req, res) => {
       const updateid = req.params.id;
    
        if(!updateid){
            return res.json(
                {
                    message : "user _id is required"
                }
            )
        };
        const {usernum, pass, mail} = req.body;
        let updatingprop = {};
        if(usernum){
            updatingprop.usernum = usernum;
        };
        if(pass){
            const saltrange = 10;
            const salt = await bcrypt.genSalt(saltrange);
            updatingprop.pass = await bcrypt.hash(pass, salt);
        }
        if(mail){
            updatingprop.mail = mail;
        }
    
        
        try {
            const updateeuser = await user.findByIdAndUpdate( updateid, updatingprop, {new : true});
            if(!updateeuser){
                return res.json({
                    message : "There is no user like this",
                })
            };
            
            res.json({
                message : "Updated successfully",
                updateeuser
            })
        } catch (error) {
            console.log("Error while Updating user :", error)
        }
}

exports.deleteuser = async (req, res) => {
     await user.findByIdAndDelete(req.params.id);
        res.json(
          { 
            message: 'User deleted' 
          }
        );
}

exports.loginappuser = async(req, res) => {
    const { usernum, pass } = req.body;
        
            try {
              const userr = await user.findOne({ usernum });
              if (!userr) {
                return res.status(400).json({ message: 'Invalid credentials' });
              }
        
              const isMatch = await bcrypt.compare(pass, userr.pass);
              if (!isMatch) {
                return res.status(400).json({ message: 'Invalid credentials' });
              }
        
              res.status(200).json({ message: 'Login successful' });
            } catch (error) {
              res.status(500).json({ message: error });
            }
}

exports.forgetapppass = async(req, res) => {
     const {usernum} = req.body;
        try {
            const userdet = await user.findOne({usernum});
            if(!userdet){
                return res.status(404).json({message : "No mobie number"})
            }
    
            const registertime = userdet.createdAt.toLocaleString();
            res.status(200).json({
                email : userdet.mail,
                time : registertime
            })
            
        } catch (error) {
            res.status(500).json({message : "Error while sending",error})
        }
}