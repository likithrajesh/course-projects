var db_handler = require('./db_handler');
var fs = require('fs');

exports.running = async (req,res)=>{
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    if(ses_data){
        const qstrng = "select t.course_id,c.title from teaches as t,course as c where t.year = \'"+ process.env.CURR_YEAR+"\' and t.semester = \'" + process.env.CURR_SEMESTER +"\' and c.course_id = t.course_id;";
        console.log(qstrng);
        const result = await db_handler.fetchquery(qstrng);
        res.send(JSON.stringify(result.rows));
        res.end();
    }
}

exports.course_dets = async (req,res) => {
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    if(ses_data){
        const qstrng = "select title,credits from course where course.course_id = \'" + req.params.course_id + "\';";
        const result = await db_handler.fetchquery(qstrng);
        const qstrng2 = "select title from prereq , course where course.course_id = prereq.prereq_id and prereq.course_id = \'" + req.params.course_id +"\';"
        const result2 = await db_handler.fetchquery(qstrng2);
        var final_result = result.rows[0];
        final_result.prereq = result2.rows;
        res.send(JSON.stringify(final_result));
        res.end();
    }
}

exports.runn_deps = async (req,res) => {
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    if(ses_data){
        const qstrng = "select distinct dept_name from section as s,course as c where s.course_id = c.course_id and s.year = \'" + process.env.CURR_YEAR + "\' and s.semester = \'"+process.env.CURR_SEMESTER+"\';";
        const result = await db_handler.fetchquery(qstrng);
        res.send(JSON.stringify(result.rows));
        res.end();
    }
}

exports.runn = async (req,res) => {
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    if(ses_data){
        const qstrng = "select s.course_id,c.title from section as s,course as c where s.course_id = c.course_id and s.year = \'" + process.env.CURR_YEAR + "\' and s.semester = \'"+process.env.CURR_SEMESTER+"\' and c.dept_name = \'"+ req.params.dept_name +"\';"
        const result = await db_handler.fetchquery(qstrng);
        res.send(JSON.stringify(result.rows));
        res.end();
    }
}