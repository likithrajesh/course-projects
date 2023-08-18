import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom'
import './running.css'
import { urlqrystrng } from './funcs';

export function Running(){
    var [ddata,setddata] = useState([])
    var session_params = {};
    if(sessionStorage.getItem("session")){
        session_params.sessionid =  JSON.parse(sessionStorage.getItem("session")).sid
    }
    useEffect(()=>{
        fetch("http://localhost:8888/runn_deps?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'})
        .then(async (response) => {
            let data = await response.json();
            setddata(curr => [...curr,...data]);
        })
    },[])
    return (
        <div className='running_page'>
            <p>LIST OF ALL DEPARTMENTS OFFERING COURSES THIS SEMESTER</p>
            <div id='dep_list'>
            {
                ddata.map((value,key)=>{
                    let linkStr = "http://localhost:3000/course/running/" + value.dept_name
                    return (
                        <p key={key}><a href={linkStr}>{value.dept_name}</a></p>
                    )
                })
            }
            </div>
        </div>

    )
}

export function RDeps(){
    let {dept_name} = useParams();
    var [dcdata,setdcdata] = useState([]);
    var session_params = {};
    if(sessionStorage.getItem("session")){
        session_params.sessionid =  JSON.parse(sessionStorage.getItem("session")).sid
    }
    useEffect(()=>{
        fetch("http://localhost:8888/runn_deps/"+ dept_name +"?" + urlqrystrng({"sid" : session_params.sessionid}),{method:'get',mode:'cors'})
        .then(async (response) => {
            let data = await response.json();
            setdcdata(curr => [...curr,...data]);
        })
    },[]);
    return (
        <div className='running_page'>
        <p>List of courses offered by {dept_name} department this semester</p>
        <div id='rdclist'>
            {
                dcdata.map((value,key) => {
                    let linkStr = "http://localhost:3000/course/" + value.course_id;
                    return (
                        <p key={key}>{value.course_id} : <a href={linkStr}>{value.title}</a></p>
                    )
                })
            }
        </div>
        </div>
    )
}
// export default Running;