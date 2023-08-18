#include <cstring>
#include "type.hh"
using namespace std ;

TypeTree :: TypeTree(string temp){
    this->asitis = temp ;
    int n = temp.size() ;
    int star = 0 ;
    string dtype = "" ;
    for(int i = 0 ; i < n ; i++){
        if(temp[i] == '*'){
            star++ ;
        }
        else if(temp[i] == '['){
            int j = i + 1 ;
            string count = "" ;
            while(temp[j] != ']'){
                count = count + temp[j] ;
                j++ ;
            }
            this->indices.push_back(stoi(count)) ;
        }
    }
    this->ptr = star ;
    if((temp[0] == 'i')|| (temp[0] == 'I')){
        dtype = "int" ;
    }
    else if((temp[0] == 'f')|| (temp[0] == 'F')){
        dtype = "float" ;
    }
    else if((temp[0] == 's')|| (temp[0] == 'S')){
        if(temp[3] == 'u' || temp[3] == 'U' ){
            dtype = "struct" ;
        }
        else{
            dtype = "string" ;
        }
    }
    else if((temp[0] == 'v') || (temp[0] == 'V')){
        dtype = "void" ;
    }
    this->datatype = dtype ;
    string var = "" ;  
    if(this->datatype == "struct"){
        for(int i = 7 ; i < n ; i++){
            if((temp[i] >= 'A' && temp[i] <= 'Z') || (temp[i] >= 'a' && temp[i] <= 'z') || (temp[i] >= '0' && temp[i] <= '9') || (temp[i] == '_')){
                var = var + temp[i] ; 
            }
            else{
                break ;
            }
        }
        this->structname = var ;
    }
    else{
        this->structname = "" ;
    }
}
TypeTree::TypeTree(TypeTree *temp){
    this->datatype = temp->datatype ;
    this->ptr = temp->ptr ;
    this->indices = temp->indices ;
    this->structname = temp->structname ;
}

bool iscompatible(TypeTree *node1, TypeTree *node2){
    bool ans = true ;
    if(node1->datatype == "void" || node2->datatype == "void"){
        if(node1->datatype == "void"){
            if(node2->datatype == "float" || node2->datatype == "int"){
                if(node1->ptr == 0){
                    if(node2->ptr > 0 || node2->indices.size() > 0){
                        ans = false ;
                        return ans ;
                    }
                }
                else if(node1->ptr > 0){
                    if(node2->ptr > 0 || node2->indices.size() > 0){

                    }
                    else{
                        ans = false ;
                        return ans ;
                    }                    
                }
            }
            else if(node2->datatype == "struct"){
                if(node2->ptr != node1->ptr){
                    ans = false ;
                    return ans ;
                }
            }
        }
        if(node2->datatype == "void"){
            if(node1->datatype == "float" || node1->datatype == "int"){
                if(node2->ptr == 0){
                    if(node1->ptr > 0 || node1->indices.size() > 0){
                        ans = false ;
                        return ans ;
                    }
                }
                else if(node2->ptr > 0){
                    if(node1->ptr > 0 || node1->indices.size() > 0){

                    }
                    else{
                        ans = false ;
                        return ans ;
                    }
                }                
            }
            else if(node2->datatype == "struct"){
                if(node1->ptr != node2->ptr){
                    ans = false ;
                    return ans ;
                }
            }
        }
    }
    if((node1->datatype == "struct") && (node2->datatype == "int" || node2->datatype == "float")){
        ans = false ;
        return ans ;
    }
    if((node2->datatype == "struct") && (node1->datatype == "int" || node1->datatype == "float")){
        ans = false ;
        return ans ;
    }
    if((node1->datatype == "struct") && (node2->datatype == "struct")){
        if(node1->structname != node2->structname){
            ans = false ;
            return ans ;
        }
    }
    return ans ;
}

string cast(TypeTree *node1, TypeTree *node2){
    string final = "" ;
    if((node1->datatype == "int" && node2->datatype == "int") || (node1->datatype == "float" && node2->datatype == "float")){
        final = "" ;
    }
    else{
        if(node1->datatype == "int" && node2->datatype == "float"){
            final = "FLOAT" ;
        }
        else{
            final = "INT" ;
        }
    }
    return final ;
}

bool ptrcompatible(TypeTree *node1, TypeTree *node2){
    bool ans = true ;
    if(node1->ptr != node2->ptr){
        ans = false ;
        return ans ;
    }
    else{
        if(node1->datatype != node2->datatype){
            ans = false ;
            return ans ;
        }
    }
    if(node1->indices.size() != node2->indices.size()){
        ans = false ;
        return ans ;
    }
    else{
        if(node1->datatype != node2->datatype){
            ans = false ;
            return ans ;
        }
    }
    return ans ;
}