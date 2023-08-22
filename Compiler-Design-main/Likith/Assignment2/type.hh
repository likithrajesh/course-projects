#ifndef TYPE_H
#define TYPE_H

#include <iostream>
#include <string>
#include <vector>
#include <map>
using namespace std ;

class TypeTree{
    public:
    string datatype ; // can be int. float, struct, string
    int ptr ;
    vector<int> indices ;
    string structname ;
    TypeTree(string temp) ;
    TypeTree(TypeTree *temp) ;
    string asitis ;
};
bool iscompatible(TypeTree *node1, TypeTree *node2) ;
bool ptrcompatible(TypeTree *node1, TypeTree *node2) ;
string cast(TypeTree *node1, TypeTree *node2) ;
#endif 