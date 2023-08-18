import './Home.css';
import {useState,useEffect} from 'react';
import { urlqrystrng } from './funcs';

// function objToQueryString(obj) {
//     const keyValuePairs = [];
//     for (const key in obj) {
//         keyValuePairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(obj[key]));
//     }
//     return keyValuePairs.join('&');
// }

function Home(){
    var [semtables,setsemtabs] = useState([]);
    var [curr_sem,setCurrsem] = useState([]);
    var [gdata,setgdata] = useState({
        "name"  : "placeHolder",
        "id" : "placeholder",
        "dept_name" : "placeholder",
        "tot_cred" : "placeholder"
    })
    var [cdata,setcdata] = useState([])
    var session_params = {};
    if(sessionStorage.getItem("session")){
        let ses_info = JSON.parse(sessionStorage.getItem("session"));
        session_params.sessionid =  ses_info.sid
        session_params.year = ses_info.curr_year;
        session_params.sem = ses_info.sem;
    }
    console.log(session_params)
    const handler = (course_id)=>{
        console.log("deregister this course");
        //handle the db query
        fetch("http://localhost:8888/deregister?" + urlqrystrng({"sid" : session_params.sessionid,"course_id" : course_id}),{method:'get',mode:'cors'})
        .then(async (response) =>{
            let result = await response.json();
            console.log(result);
        })

        // also after sending a req to server reload the page
        //      may be a state var to update useEffect!!
    }
    useEffect(()=>{
        // console.log()
        fetch("http://localhost:8888/home" + "?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'}).then(async (response)=>{
            let data = await response.json();
            // console.log(data);
            setgdata(data);
        })
    },[])
    
    useEffect(() =>{
        fetch("http://localhost:8888/home/coursedets"+ "?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'}).then(async (response) =>{
            let data = await response.json();
            // console.log(data);
            setcdata(data);
        })
    },[])

    useEffect(() => {
        console.log(cdata.length)
        if(cdata.length){
            // Adjust data accordingly
            let year = cdata[0].year;
            let sem = cdata[0].semester;
            
            let curr_tab_data = [];
            for (let i = 0; i<cdata.length; i++){
                if(cdata[i].year === session_params.year && cdata[i].semester === session_params.sem){
                    setCurrsem(curr => [...curr,cdata[i]])
                    continue;
                }
                if(cdata[i].year === year && cdata[i].semester === sem){
                    curr_tab_data.push(cdata[i]);
                } else {
                    semtables.push(
                    <div key={year+sem} className="internalTabs">
                    <p>Year : {year} and Semester : {sem}</p>
                    <table>
                        <colgroup>
                            <col width="20%"/>
                            <col width="50%"/>
                            <col width="15%"/>
                            <col width="15%"/>
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>Course Id</th>
                            <th>Course name</th>
                            <th>Credits</th>
                            <th>Grade</th>
                        </tr>
                        {
                            curr_tab_data.map((val, key) => {
                                return (
                                    <tr key={key}>
                                    <td>{val.cid}</td>
                                    <td>{val.cname}</td>
                                    <td>{val.credits}</td>
                                    <td>{val.grade}</td>
                                    </tr>
                                )
                            })
                        }
                        </tbody>
                    </table></div>);
                    year = cdata[i].year;
                    sem = cdata[i].semester;
                    curr_tab_data = [];
                    curr_tab_data.push(cdata[i]);
                }
            }
            setsemtabs([...semtables,<div key={year+sem} className="internalTabs">
                <p>Year : {year} and Semester : {sem}</p>
                <table>
                <colgroup>
                    <col width="20%"/>
                    <col width="50%"/>
                    <col width="15%"/>
                    <col width="15%"/>
                </colgroup>
                <tbody>
                <tr>
                    <th>Course Id</th>
                    <th>Course Name</th>
                    <th>Credits</th>
                    <th>Grade</th>
                </tr>
                {
                    curr_tab_data.map((val, key) => {
                        return (
                            <tr key={key}>
                            <td>{val.cid}</td>
                            <td>{val.cname}</td>
                            <td>{val.credits}</td>
                            <td>{val.grade}</td>
                            </tr>
                        )
                    })
                }
                </tbody>
            </table></div>]);
        }
    },[cdata])

    return (
        <div className='homepage'>
            <div id='genData'>
                ID : {gdata.id}
                <br/>
                Name : {gdata.name}
                <br/>
                Department : {gdata.dept_name}
                <br/>
                Total Credits : {gdata.tot_cred}
            </div>
            <div id='currsem'>
                <p>Current semester</p>
                <p>Year : {session_params.year} | Semester : {session_params.sem}</p>
                <div className="internalTabs">
                    <table>
                        <colgroup>
                            <col width="20%"/>
                            <col width="50%"/>
                            <col width="15%"/>
                            <col width="15%"/>
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>Course Id</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                            <th>?Drop?</th>
                        </tr>
                        {
                            curr_sem.map((val, key) => {
                                return (
                                    <tr key={key}>
                                    <td>{val.cid}</td>
                                    <td>{val.cname}</td>
                                    <td>{val.credits}</td>
                                    <td><button onClick={handler(val.cid)}>DROP</button></td>
                                    </tr>
                                )
                            })
                        }
                        </tbody>
                    </table>
                </div>
            </div>
            <div id='semtabs'>
                {semtables}
            </div>
        </div>
    )
}

export default Home;