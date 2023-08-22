#include <algorithm>
#include "registers.hh"

RegisterStack :: RegisterStack(){
    this->registers.push("%edi") ;
    this->registers.push("%esi") ;
    this->registers.push("%edx") ;
    this->registers.push("%ecx") ;
    this->registers.push("%ebx") ;
    this->registers.push("%eax") ;
}