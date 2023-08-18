var db_handler = require('./db_handler');
var bcrypt = require('bcrypt');
// var util = require('util');
var fs = require('fs');

// authentication
async function checkHash(hash,password) {
    return await bcrypt
      .compare(password, hash)
      .then(res => {
        console.log(res) // return true
        return res;
      })
      .catch(err => console.error(err.message))        
}

async function valuser (req,res) {
    const qstrng = "select hashed_password from user_password where id = \'" + req.body.username + "\';";
    const result = await db_handler.fetchquery(qstrng);
    // console.log(result)
    if(result.rowCount){
        const isver = await checkHash(result.rows[0].hashed_password,req.body.password);
        if(isver){
            
            var session=req.session;
            session.userid=req.body.username;
            session.sid=session.id;
            session.curr_year=process.env.CURR_YEAR;
            session.sem=process.env.CURR_SEMESTER;
            console.log(session)
            // sessionStorage.push(session);
            fs.writeFile(process.env.SSTORAGE + "/" + session.id,JSON.stringify(session),(err)=>{
                if (err) throw err;
                console.log("Session with id " + session.id + " saved to " + process.env.SSTORAGE)
            });
            res.send(session);
            res.end();
        }
    } else {
        res.end();
    }
}

module.exports = {valuser}