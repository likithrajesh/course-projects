#include <cstring>
#include <algorithm>
#include "assembly.hh"
using namespace std ;

Result :: Result(){
    this->stringcount = 0 ; // for lc count 
    this->funname = "" ; // to store the current fucntion name
    this->result.clear() ;
    this->reg = "" ;
}