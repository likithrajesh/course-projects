import { useEffect, useState } from 'react';
import { urlqrystrng } from './funcs';
import './regis.css'

function Regis(){
    var [searchResults,setSresults] = useState([]);
    var [mdata,setmdata] = useState([]);
    // fetch all current running courses initially
    var session_params = {};
    if(sessionStorage.getItem("session")){
        session_params.sessionid =  JSON.parse(sessionStorage.getItem("session")).sid
    }
    useEffect(()=>{
        fetch("http://localhost:8888/course/running?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'})
        .then(async (response) => {
            let data = await response.json();
            setmdata(curr => [...curr,...data]);
        })
    },[])

    const handler = ()=>{
        //clear the results area before showing new results
        document.getElementById("searchResults").innerHTML = "";
        let searchval = document.getElementById("searchtxt").value;
        if(searchval){
            let filter_data = mdata.filter((obj) => {return obj.course_id.match(searchval) || obj.title.toLowerCase().includes(searchval.toLowerCase())})
            setSresults(curr => [...curr,...filter_data]);
        }
        
        // console.log(searchval);
    }
    const handler2 = (course_id) => {
        // get curr year course details of user 
        fetch("http://localhost:8888/registerCourse?" + urlqrystrng({"sid" : session_params.sessionid,"course_id" : course_id,"sec_id" : 2}),{method:'get',mode:'cors'})
        .then(async (response) =>{
            let data = await response.json();
            console.log(data.success);
        })
        console.log("registering for course" + course_id);
    }
    return (
        <div id="regpage">
            <h1>Registration page</h1>
            <div id='searchbox'>
                <input type="text" id='searchtxt' placeholder="Search"/>
                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                <button onClick={handler}>Search</button>
            </div>
            <div id='searchResults'>
                {
                    searchResults.map((value,key) => {
                        return (
                            <div className='regisEntries' key={key}>
                                <p className='regEn'>{value.course_id}</p> : {value.title} : &nbsp; &nbsp; <button onClick={() => {handler2(value.course_id)}}>REGISTER</button>
                            </div>
                        )
                    })
                }
            </div>
        </div>
    )
}

export default Regis;