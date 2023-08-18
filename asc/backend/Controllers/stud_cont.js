var db_handler = require('./db_handler');
var fs = require('fs')

exports.stud_profile =  async (req,res) => {
    // console.log(req.query.sid);
    // get the user id from the sesison file in sessionStorage
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    var uid = JSON.parse(ses_data).userid;
    if(uid){
        const qstrng = "select * from student where id = \'" + uid + "\';";
        const result = await db_handler.fetchquery(qstrng);
        res.send(JSON.stringify(result.rows[0]));
        res.end();
    }
}

exports.course_dets = async (req,res) => {
    //first fetch for a session existence
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    var uid = JSON.parse(ses_data).userid;
    if(uid){
        const qstrng = "select t.year as year,t.semester as semester,t.course_id as cid,c.title as cname,c.credits as credits,t.grade as grade from takes as t,course as c where t.course_id = c.course_id and id = \'" + uid + "\' order by year desc,semester desc;";
        const result = await db_handler.fetchquery(qstrng);
        res.send(JSON.stringify(result.rows));
        res.end();
    }
}