import {useParams} from 'react-router-dom';
import {useState,useEffect} from 'react';
import './prof.css';
import { urlqrystrng } from './funcs';

function Prof() {
    let {instructor_id} = useParams();
    var [pdata,setpdata] = useState({
        "name" : "placeholder",
        "dept_name" : "placeholder",
        "cUtaken" : []
    });
    var session_params = {};
    if(sessionStorage.getItem("session")){
        let ses_info = JSON.parse(sessionStorage.getItem("session"));
        session_params.sessionid =  ses_info.sid
    }
    useEffect(()=>{
        fetch("http://localhost:8888/instructor/" + instructor_id + "?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'})
        .then(async (response) => {
            let data = await response.json();
            console.log(data);
            setpdata(data);
        })
    },[]);
    return (
        <div id='ins_page'>
            ID : {instructor_id} <br/>
            Name : {pdata.name} <br/>
            Department : {pdata.dept_name} <br/>
            <div id='ctabs'>
                <table>
                    <tbody>
                        <tr>
                            <th>Course Id</th>
                            <th>Course name</th>
                            <th>year</th>
                        </tr>
                        {
                            
                            pdata.cUtaken.map((val,key)=>{
                                return (
                                    <tr key={key}>
                                        <td>{val.course_id}</td>
                                        <td>{val.title}</td>
                                        <td>{val.year}</td>
                                    </tr>
                                )
                            })
                        }
                    </tbody>
                </table>
            </div>
        </div>

    )
}

export default Prof;