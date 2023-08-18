var db_handler = require('./db_handler');
var fs = require('fs');
const { t } = require('tar');


exports.deregister = async (req,res) => {
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    var uid = JSON.parse(ses_data).userid;
    if(ses_data){
        const qstrng = "delete from takes where id = \'" + uid + "\' and course_id = \'" + req.query.course_id + "\';"
        console.log(qstrng);

        const result = await db_handler.fetchquery(qstrng);
        if(result){
            res.send(JSON.stringify({"success" : true}));

        } else {
            res.send(JSON.stringify({"success" : false}));
        }
        res.end();
    }
}

exports.registerCourse = async (req,res) => {
    const ses_data = await fs.readFileSync(process.env.SSTORAGE + "/" + req.query.sid,{encoding:'utf-8'});
    var uid = JSON.parse(ses_data).userid;
    if(ses_data){
        const qstrng1 = "with a as ( select course_id as c1 from takes where id = \'" + uid 
                        + "\' and year != \'" + process.env.CURR_YEAR 
                        +"\' and semester != \'"+ process.env.CURR_SEMESTER
                        +"\'), b as ( select prereq_id as c1 from prereq where course_id = \'" + req.query.course_id 
                        +"\') select count(*) = 0 as equal from b left join a using (c1) where a.c1 is null;";
        const result = await db_handler.fetchquery(qstrng1);
        // getting current time slots that are busy for user;
        // add sections later
        const qstrng2 = "with t1 as (with a as (select s.time_slot_id from section as s,takes as t where t.id = \'"+ uid
                        +"\' and t.year = \'"+process.env.CURR_YEAR
                        +"\' and t.semester = \'"+process.env.CURR_SEMESTER
                        +"\' and s.course_id = t.course_id) select a.time_slot_id,day,start_hr::integer,start_min::integer,end_hr::integer,end_min::integer from time_slot, a where a.time_slot_id = time_slot.time_slot_id),"+
                        "t2 as (select section.time_slot_id,day,start_hr::integer,start_min::integer,end_hr::integer,end_min::integer from section,time_slot where section.time_slot_id = time_slot.time_slot_id and section.course_id = \'"+ req.query.course_id
                        +"\' and section.sec_id = \'"+1
                        +"\') "+
                        "select * from t1,t2 "+
                        "where t1.time_slot_id = t2.time_slot_id"+
                        " or "+
                        "(t1.day = t2.day and t1.time_slot_id != t2.time_slot_id"+
                        " and "+
                        "(" + 
                        "((t2.start_hr*60 + t2.start_min)::integer between (t1.start_hr*60 + t1.start_min)::integer and (t1.end_hr*60 + t1.end_min)::integer)" + " or " +
                        "((t2.end_hr*60 + t2.end_min)::integer between (t1.start_hr*60 + t1.start_min)::integer and (t1.end_hr*60 + t1.end_min)::integer)"+ " or " +
                        "((t1.start_hr*60 + t1.start_min)::integer between (t2.start_hr*60 + t2.start_min)::integer and (t2.end_hr*60 + t2.end_min)::integer)"+
                        ")"+
                        ");"
        const result2 = await db_handler.fetchquery(qstrng2);
        const qstrng4 = "select course_id from takes where takes.id = \'"+uid+"\' and takes.course_id = \'" + req.query.course_id +"\' and (takes.year != \'"+process.env.CURR_YEAR+"\' or takes.semester != \'"+process.env.CURR_SEMESTER+"\');"
        const result4 = await db_handler.fetchquery(qstrng4);
        if(result.rows[0].equal && result2.rowCount === 0 && result4.rowCount === 0){
            const qstrng3 = "insert into takes values ('"+uid+"','"+req.query.course_id+"','"+req.query.sec_id+"','"+process.env.CURR_SEMESTER+"','"+process.env.CURR_YEAR+"',"+"'NA')";
            console.log(qstrng3)
            const result3 = await db_handler.fetchquery(qstrng3);
            res.send(JSON.stringify({"success" : true}));

        } else {
            res.send(JSON.stringify({"success" : false}));
        }
        res.end();
    }
}


const mystring = "with t1 as (with a as (select s.time_slot_id from section as s,takes as t where t.id = '24746' and t.year = '2010' and t.semester = 'Fall' and s.course_id = t.course_id) select a.time_slot_id,day,start_hr::integer,start_min::integer,end_hr::integer,end_min::integer from time_slot, a where a.time_slot_id = time_slot.time_slot_id),"+
                "t2 as (select section.time_slot_id,day,start_hr::integer,start_min::integer,end_hr::integer,end_min::integer from section,time_slot where section.time_slot_id = time_slot.time_slot_id and section.course_id = '867' and section.sec_id = '1') "+
                "select * from t1,t2 "+
                "where t1.time_slot_id = t2.time_slot_id"+
                " or "+
                "(t1.day = t2.day and t1.time_slot_id != t2.time_slot_id"+
                " and "+
                "(" + 
                "((t2.start_hr*60 + t2.start_min)::integer between (t1.start_hr*60 + t1.start_min)::integer and (t1.end_hr*60 + t1.end_min)::integer)" + " or " +
                "((t2.end_hr*60 + t2.end_min)::integer between (t1.start_hr*60 + t1.start_min)::integer and (t1.end_hr*60 + t1.end_min)::integer)"+ " or " +
                "((t1.start_hr*60 + t1.start_min)::integer between (t2.start_hr*60 + t2.start_min)::integer and (t2.end_hr*60 + t2.end_min)::integer)"+
                ")"+
                ");"