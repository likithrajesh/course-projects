import './course.css';
import {useParams} from 'react-router-dom';
import {useState,useEffect} from 'react';
import { urlqrystrng } from './funcs';

function Course(){
    let {course_id} = useParams();
    var [cdata,setcdata] = useState({
        "title" : "junk",
        "credits" : "junk",
        "prereq" : []
    })
    var session_params = {};
    if(sessionStorage.getItem("session")){
        session_params.sessionid =  JSON.parse(sessionStorage.getItem("session")).sid
    }
    useEffect(()=>{
        fetch("http://localhost:8888/course/" + course_id + "?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'})
        .then(async (response) => {
            let data = await response.json();
            console.log(data);
            setcdata(data);
        })
    },[]);
    return (
        <div id='course_page'>
            Course Id : {course_id} <br/>
            Course Name : {cdata.title} <br/>
            Credits : {cdata.credits} <br/>
            Pre-requisites : {
                cdata.prereq.map((value,key)=>{
                    return(
                        <p key={key}>{value.title}</p>
                    )
                })
            }
        </div>
    )
}

export default Course;