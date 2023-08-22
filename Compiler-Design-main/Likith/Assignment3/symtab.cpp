#include "symtab.hh"

varinfo :: varinfo(string param1, string param2, string param3, int param4, int param5, string param6){
    this->name = param1 ;
    this->type = param2 ;
    this->scope = param3 ;
    this->size = param4 ;
    this->offset = param5 ;
    this->datatype = param6 ;
}

localsymboltable :: localsymboltable(varinfo* param1){
    this->entry = param1 ;
} 

globalsymboltable :: globalsymboltable(varinfo* param1){
    this->entry = param1 ;
} 

/*
void localsymboltable :: display_varinfo(){
    string start = "[   \"" ;
    string middle = "\",   \"" ;
    string node = start + this->entry->name + middle + this->entry->type + middle + this->entry->scope ;
    cout<<node ;
    cout<<"\",   " ;
    cout<<this->entry->size ;
    middle = ",     " ;
    cout<<middle ;
    cout<<this->entry->offset ;
    middle = ",     \"" ;
    cout<<middle ;
    cout<<this->entry->datatype + "\"\n]" ;
}

void varinfo :: display_varinfo(int blanks){
    string blankspace = string(blanks, ' ') ;

    string varname = blankspace + "\"" + this->name + "\"," ;
    string vartype = blankspace + "\"" + this->type + "\"," ;
    string varscope = blankspace + "\"" + this->scope + "\"," ;

    cout<<varname<<endl ;
    cout<<vartype<<endl ;
    cout<<varscope<<endl ;

    if(this->type == "function"){
        cout<<blankspace<<0<<","<<endl ;
        cout<<blankspace<<0<<","<<endl ;
        string var_type = blankspace + "\"" + this->datatype + "\"" ;
        cout<<var_type<<endl ; 
    }
    else if(this->type == "struct"){
        cout<<blankspace<<this->size<<","<<endl ;
        cout<<blankspace<<"\"-\","<<endl ;
        cout<<blankspace<<"\"-\""<<endl ;
    }
    else{
        cout<<blankspace<<this->size<<","<<endl ;
        cout<<blankspace<<this->offset<<","<<endl ;
        string var_type = blankspace + "\"" + this->datatype + "\"" ;
        cout<<var_type<<endl ; 
    }
}


void globalsymboltable :: display_varinfo(){
    string start = "[   \"" ;
    string middle = "\",   \"" ;
    string node = start + this->entry->name + middle + this->entry->type + middle + this->entry->scope  ;
    cout<<node ;
    middle = "\",   " ;
    if(this->entry->type == "struct"){
        cout<<middle ;
        cout<<this->entry->size ;
        cout<<",    \"-\",    \""<<this->entry->datatype<<"\"\n]" ;
    }
    else if(this->entry->type == "function"){
        cout<<middle ;
        cout<<0 ;
        middle = ",   " ;
        cout<<middle ;
        cout<<0 ;
        middle  = ",   \"" ;
        cout<<middle ;
        cout<<this->entry->datatype<<"\"\n]" ;
    }
    else{
        cout<<middle ;
        cout<<this->entry->size ;
        middle = ",   " ;
        cout<<middle ;
        cout<<this->entry->offset ;
        middle  = ",   \"" ;
        cout<<middle ;
        cout<<this->entry->datatype<<"\"\n]" ;   
    }
}
*/

int funcreqsize(string fname, map<string, vector<varinfo*>> fst){
    int size = 0 ;
    int i = 0 ;
    int n = fst.find(fname)->second.size() ;
    while(i < n){
        size = size + fst[fname][i]->size ;
        i++ ;
    }
    return size ;
}

int returnoffset(string fname, string varname, map<string, vector<varinfo*>> fst){
    int offset = 0 ;
    int i = 0 ;
    int n = fst.find(fname)->second.size() ;
    while(i < n){
        if(fst.find(fname)->second[i]->name == varname){
            offset = fst.find(fname)->second[i]->offset ;
            break ;
        }
        i++ ;
    }
    return offset ;
}

int localsize(string fname, map<string, vector<varinfo*>> fst){
    int size = 0 ;
    int i = 0 ;
    int n = fst.find(fname)->second.size() ;
    while(i < n){
        if(fst[fname][i]->scope == "local"){
            size = size + fst[fname][i]->size ;
        }
        i++ ;
    }
    return size ;
}

int paramsize(string fname, map<string, vector<varinfo*>> fst){
    int size = 0 ;
    int i = 0 ;
    int n = fst.find(fname)->second.size() ;
    while(i < n){
        if(fst[fname][i]->scope == "param"){
            size = size + fst[fname][i]->size ;
        }
        i++ ;
    }
    return size ;

}

int funcreqoffset(string fname, map<string, vector<varinfo*>> fst){
    int offset = 0 ;
    int i = 0 ; 
    int n = fst.find(fname)->second.size() ;
    while(i < n){
        if(fst[fname][i]->offset <= offset){

        }
        else{
            offset = fst[fname][i]->offset ;
        }
        i++ ;
    }
    return offset ;
}

int structreqsize(string structname, string varname, map<string, vector<varinfo*>> sst){
    int i = 0 ;
    int size = 0 ;
    int n = sst.find(structname)->second.size() ;
    auto it = sst.find(structname) ;
    while(i < n){
        if(it->second[i]->name == varname){
            size = it->second[i]->size ;
            break ;
        }
        i++ ;
    }
    return size ;
}

string structname(string fname, string varname, map<string, vector<varinfo*>> fst){
    int i = 0 ;
    string type = "" ;
    int n = fst.find(fname)->second.size() ;
    auto it = fst.find(fname) ;
    while(i < n){
        if(it->second[i]->name == varname){
            type = it->second[i]->datatype ;
            break ;
        }
        i++ ;
    }
    return type ;
}

int numberofvariables(string fname, map<string, vector<varinfo*>> fst){
    int n = 0 ;
    n = fst.find(fname)->second.size() ;
    return n ;
}

