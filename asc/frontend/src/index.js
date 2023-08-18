import React from 'react';
import ReactDOM from 'react-dom/client';
import Login from './login';
import Home from './Home';
import { Routes, Route, BrowserRouter as Router } from 'react-router-dom';
import Regis from './regis';
import Prof from './prof';
import Course from './course';
import { RDeps, Running } from './running';

export default function Rout () {
    return (
        <Router>
            <Routes>
            <Route exact path='/' element={< Login />}></Route>
            <Route exact path='/home' element={< Home />}></Route>
            <Route exact path='/login' element={< Login />}></Route>
            <Route exact path='/home/registration' element={<Regis />}></Route>
            <Route exact path='/instructor/:instructor_id' element={<Prof />}></Route>
            <Route exact path='/course/running' element={<Running />}></Route>
            <Route exact path='/course/running/:dept_name' element={<RDeps />}></Route>
            <Route exact path='/course/:course_id' element={<Course />}></Route>
            </Routes>
        </Router>
    );
}


const display = ReactDOM.createRoot(document.getElementById('root'));
display.render(
    <Rout />
);
// const nav = ReactDOM.createRoot(document.getElementById('nav'));
// nav.render(
//     <Nav />
// );