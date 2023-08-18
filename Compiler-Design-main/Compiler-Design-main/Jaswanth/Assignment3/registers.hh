#ifndef REGISTERS_H
#define REGISTERS_H

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <stack>
using namespace std ;

class RegisterStack{
    public:
    stack<string> registers ; 
    stack<string> curr_registers ; 
    RegisterStack() ;
};
#endif 