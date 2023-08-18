#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <iostream>
#include <string>
#include <vector>
#include <map>
using namespace std ;

class Result{
    public:
    int stringcount ;
    string funname ; 
    map<string, vector<string>> result ; 
    string reg ; 
    Result() ;
};
#endif 