// Load environment variables
var dotenv = require('dotenv');
    // Delete the options provided while submitting
dotenv.config();
console.log(process.env.PG_HOST);

var fs = require('fs');

var express = require('express');
var path = require('path');
var cors = require('cors');


var app = express();

// import controllers here
var auth = require('./Controllers/login_cont');
var sprofile = require('./Controllers/stud_cont');
var course = require('./Controllers/course_cont');
var prof = require('./Controllers/prof_cont');
var regis = require('./Controllers/regis_cont');

var cookieParser = require('cookie-parser');
var sessions = require('express-session');

// app.use(express.bodyParser())
// app.use(express.cookieParser())
// app.use(express.methodOverride())
// app.use(app.router)
// app.use(allowCrossDomain)

const onehour = 60*60*1000;
// app.use(cookieParser);
console.log(process.env.SESSION_SKEY)
app.use(sessions({
    secret: process.env.SESSION_SKEY,
    saveUninitialized: true,
    cookie: {maxAge: onehour},
    resave: false
}))

app.use(express.static(path.join(__dirname,'public')));
app.use(express.json());       
app.use(express.urlencoded({extended: true})); 
app.use(cors({
    "origin": "*",
    "methods": "GET,HEAD,PUT,PATCH,POST,DELETE",
    "preflightContinue": false,
    "optionsSuccessStatus": 204,
    "credentials": true,
    "Access-Control-Allow-Origin": "*"
}));

// Handle post requests here
app.post('/login',auth.valuser);


// Handle get requests here
app.get('/home',sprofile.stud_profile);
app.get('/home/coursedets',sprofile.course_dets);
app.get('/course/running',course.running);
app.get('/course/:course_id',course.course_dets);
app.get('/instructor/:ins_id',prof.prof_dets);
app.get('/runn_deps',course.runn_deps);
app.get('/runn_deps/:dept_name',course.runn);
app.get('/deregister',regis.deregister);
app.get('/registerCourse',regis.registerCourse);

app.get('/logout',(req,res) => {
    fs.unlink(process.env.SSTORAGE + "/" + req.session.id,(err)=>{
        if (err) throw err;
    })
    req.session.destroy();
    res.send("U r successfully logged out. <a href='localhost:3000/login'>login</a>")
})

var server = app.listen(8888,() => {
    var host = server.address().address;
    var port = server.address().port;
    console.log("example app listening at http://%s:%s",host,port);
})


































// lets hash and encrpt the passwords
// var ex_password = "jaswanth@2002";
// async function hashit(pswd,sr){
//     var inhash;
//     await bcrypt.genSalt(sr).then(salt => {
//         // console.log('Salt: ', salt);
//         return bcrypt.hash(pswd, salt);
//     })
//     .then(hash => {
//         // console.log('Hash: ', hash);
//         inhash = hash;
//     })
//     .catch(err => console.error(err.message));
//     return inhash;
// }
// console.log(hashit(ex_password,saltrounds));
