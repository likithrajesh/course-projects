var db_handler = require('./db_handler');
var fs = require('fs');

exports.prof_dets = async (req,res)=>{
    // console.log(req.params);
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    if(ses_data){
        const qstrng1 = "select t.course_id,c.title,t.year from teaches as t,instructor as i,course as c where t.id = i.id and i.id = \'" + req.params.ins_id + "\' and c.course_id = t.course_id order by t.course_id;";
        // console.log(qstrng1)
        const result1 = await db_handler.fetchquery(qstrng1);
        const qstrng2 = "select name,dept_name from instructor where id = \'" + req.params.ins_id + "\';";
        const result2 = await db_handler.fetchquery(qstrng2);
        var final_data = result2.rows[0];
        final_data.cUtaken = result1.rows;
        // console.log(final_data);
        res.send(JSON.stringify(final_data));
        res.end();
    }
}