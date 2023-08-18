#include<iostream>
#include<map>
#include<string>
#include<vector>

using namespace std ;

struct varinfo{
    public:
    string name ;
    string type ;
    string scope ;
    int size ;
    int offset ;
    string datatype ;

    varinfo(string param1, string param2, string param3, int param4, int param5, string param6){
        this->name = param1 ;
        this->type = param2 ;
        this->scope = param3 ;
        this->size = param4 ;
        this->offset = param5 ;
        this->datatype = param6 ;
    }

    void display_varinfo(int blanks){
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
};

class localsymboltable{
    public :
    varinfo* entry ;
    localsymboltable(varinfo* param1){
        this->entry = param1 ;
    }

    void display_varinfo(){
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
};

class globalsymboltable{
    public:
    varinfo* entry ;
    globalsymboltable(varinfo* param1){
        this->entry = param1 ;
    }

    void display_varinfo(){
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
};

