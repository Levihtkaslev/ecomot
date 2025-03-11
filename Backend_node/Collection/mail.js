const nodemailer = require("nodemailer");

let sending = nodemailer.createTransport({
    service : "gmail",
    auth : {
        user : "sakthivelveld13@gmail.com",
        pass : "tuqk gzpq wzem jwyi",
    }
});

async function sendmail(tomail, phone, pass){
    let mail = {
        from : "sakthivelveld13@gmail.com",
        to : tomail,
        subject : "Your log in info",
        text : `Your number ${phone}, your password ${pass}`
    };
    try {
        await sending.sendMail(mail)
        console.log("Mailed successfuly");
    } catch (error) {
        console.log("Error", error)
    }
}

module.exports = sendmail;