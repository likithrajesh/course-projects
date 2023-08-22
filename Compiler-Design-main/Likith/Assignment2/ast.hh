#include<iostream>
#include<string>
#include<map>
#include<vector>
#include "type.hh"
using namespace std ;

enum typeExp{
    INT,
    FLOAT,
    STRING, 
};

class abstract_astnode{
    public:

    virtual void print(int blanks) = 0 ;

    virtual bool is_empty(){
        return false ;
    } 

    virtual vector<abstract_astnode*> getseqnodes(){
        vector<abstract_astnode*> temp ;
        return temp ;
    }

    virtual abstract_astnode* getleftnode(){
        return NULL ;
    }

    virtual abstract_astnode* getrightnode(){
        return NULL ;
    }

    // enum typeExp EXP_TYPE ;
    // abstract_astnode(enum typeExp a){
    //     astnode_type = a ;
    // }
    TypeTree *node ;
    bool lvalue ;
} ;

/*
=============================================================================================================================
*/


class statement_astnode : public abstract_astnode{
    public:
    virtual void print(int blanks){} ;
};


class exp_astnode : public abstract_astnode{
    public:
    virtual void print(int blanks){};
};


class ref_astnode : public abstract_astnode{
    public:
    virtual void print(int blanks){};
};

/*
=============================================================================================================================
*/

// inheritence from exp_node 
class op_binary_astnode : public exp_astnode{
    public:

    string op ;
    abstract_astnode *left ;
    abstract_astnode *right ;

    op_binary_astnode(string op, abstract_astnode* left, abstract_astnode *right){
        this->op = op ;
        this->left = left ;
        this->right = right ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "  \"op_binary\": {" ;
        string rootnode = blankspace + "  \"op\": \"" + op + "\", " ;
        string leftnode = blankspace + "  \"left\": {" ;
        string rightnode = blankspace + "  \"right\": {" ;
        string closeleft = blankspace + "  }," ;
        string closeright = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<rootnode<<endl ;

        cout<<leftnode<<endl ;
        this->left->print(blanks+4) ;
        cout<< closeleft<<endl ;

        cout<<rightnode<<endl ;
        this->right->print(blanks+4) ;
        cout<<closeright<<endl ;

        cout<<close<<endl ;
    }
};


class op_unary_astnode : public exp_astnode{
    public:
    string op ;
    abstract_astnode* Childnode ;

    op_unary_astnode(string op, abstract_astnode* child){
        this->op = op ;
        this->Childnode = child ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"op_unary\": {" ;
        string rootnode = blankspace + "  \"op\": \"" + op + "\", " ;
        string childnode = blankspace + "  \"child\": {" ;
        string closechild = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<rootnode<<endl ; 

        cout<<childnode<<endl ;
        this->Childnode->print(blanks+4) ;
        cout<<closechild<<endl ;

        cout<<close<<endl ;
    }
};

class assignE_astnode : public exp_astnode{
    public:
    abstract_astnode* left ;
    abstract_astnode* right ;

    assignE_astnode(abstract_astnode* leftnode, abstract_astnode* rightnode){
        this->left = leftnode ;
        this->right = rightnode ;
    }

    virtual abstract_astnode* getleftnode(){
        return this->left ;
    }

    virtual abstract_astnode* getrightnode(){
        return this->right ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"assignE\": {" ;
        string leftnode = blankspace + "  \"left\": {" ;
        string rightnode = blankspace + "  \"right\": {" ;
        string closeleft = blankspace + "  }," ;
        string closeright = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<leftnode<<endl ;
        this->left->print(blanks+4) ;
        cout<<closeleft<<endl ;

        cout<<rightnode<<endl ;
        this->right->print(blanks+4) ;
        cout<<closeright<<endl ;

        cout<<close<<endl ;
    }

};

class funcall_astnode : public exp_astnode {
    public :
    abstract_astnode *funname ;
    vector<abstract_astnode*> params_list ;

    funcall_astnode(abstract_astnode *name, vector<abstract_astnode*> List){
        this->funname = name ;
        this->params_list = List ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "  \"funcall\": {" ;
        string rootnode = blankspace + "  \"fname\": {" ; 
        string closenode = blankspace + "  }," ;
        string paramsnode = blankspace + "  \"params\": [" ;
        string paramsclose = blankspace + "  ]" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<rootnode<<endl ;
        this->funname->print(blanks+4) ;
        cout<<closenode<<endl ;
        int n = params_list.size() ;
        cout<<paramsnode<<endl ;
        for(int i = 0 ; i < n ; i++){
            cout<<blankspace+"{"<<endl ;
            this->params_list[i]->print(blanks+4) ;
            cout<<blankspace+"}"<<endl ;
            if(i != n -1){
                cout<<","<<endl ;
            }
        }
        cout<<paramsclose<<endl ;

        cout<<close<<endl ;

    }
};

class intconst_astnode : public exp_astnode{
    public:
    string lex_value ;

    intconst_astnode(string value){
        this->lex_value = string(value) ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace + "\"intconst\": " + lex_value ;

        cout<<rootnode<<endl ;
    }
};

class floatconst_astnode : public exp_astnode{
    public:
    string lex_value ;

    floatconst_astnode(string value){
        this->lex_value = string(value) ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace + "\"floatconst\": " + lex_value ;

        cout<<rootnode<<endl ;
    }
};

class stringconst_astnode : public exp_astnode{
    public:
    string  lex_value ;

    stringconst_astnode(string value){
        this->lex_value = string(value) ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace + "\"stringconst\": " + lex_value ;

        cout<<rootnode<<endl ;
    }
};

// class explist_astnode : public exp_astnode{
//     public:
//     vector<abstract_astnode*> expressions_list ;

//     explist_astnode(vector<abstract_astnode*> temp){
//         this->expressions_list = temp ;
//     }

//     virtual vector<abstract_astnode*> getseqnodes(){
//         return this->expressions_list ;
//     }

//     virtual void print(int blanks){
//         string blankspace = string(blanks, ' ') ;
//         int i = 1 ;
//         int n = expressions_list.size() ;
//         string start = blankspace + "{" ;
//         string stop = blankspace + "}" ;
//         for(int j = 0 ; j < n ; j++){
//             cout<<start<<endl ;
//             this->expressions_list[j]->print(blanks+2) ;
//             cout<<stop<<endl;
//             if(j != n - 1){
//                 cout<<"," ;
//             }
//             i++ ;
//         }
//         cout<<endl ;
//     }
// };

/*
=============================================================================================================================
*/

// middle box inheritence from ref_node 
class identifier_astnode : public ref_astnode{
    public:
    string identifier_lex_value ;

    identifier_astnode(string value){
        this->identifier_lex_value = string(value) ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace + "\"identifier\": " + "\"" + identifier_lex_value + "\"" ;

        cout<<rootnode<<endl ;
    }
};

class member_astnode : public ref_astnode{
    public:
    abstract_astnode* structure ;
    abstract_astnode* field ;

    member_astnode(abstract_astnode* strct, abstract_astnode* value){
        this->structure = strct ;
        this->field = value;
    }
    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"member\": {" ;
        string structurenode = blankspace + "  \"struct\": {" ;
        string fieldnode = blankspace + "  \"field\": {" ;
        string closestructure = blankspace + "  }," ;
        string closefield = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<structurenode<<endl ;
        this->structure->print(blanks+4) ;
        cout<<closestructure<<endl ;

        cout<<fieldnode<<endl ;
        this->field->print(blanks+4) ;
        cout<<closefield<<endl ;

        cout<<close<<endl ;
    }
};


class arrayref_astnode : public ref_astnode{
    public:
    abstract_astnode* array ;
    abstract_astnode* index ;

    arrayref_astnode(abstract_astnode* arr, abstract_astnode* ind){
        this->array = arr ;
        this->index = ind ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"arrayref\": {" ;
        string arraynode = blankspace + "  \"array\": {" ;
        string indexnode = blankspace + "  \"index\": {" ;
        string closearray = blankspace + "  }," ;
        string closeindex = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<arraynode<<endl ;
        this->array->print(blanks+4) ;
        cout<<closearray<<endl ;

        cout<<indexnode<<endl ;
        this->index->print(blanks+4) ;
        cout<<closeindex<<endl ;

        cout<<close<<endl ;
    }
};

class arrow_astnode : public ref_astnode{
    public: 
    abstract_astnode* pointer ;
    abstract_astnode* field ;

    arrow_astnode(abstract_astnode *ptr, abstract_astnode* value){
        this->pointer = ptr ;
        this->field = value ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"arrow\": {" ;
        string pointernode = blankspace + "  \"pointer\": {" ;
        string fieldnode = blankspace + "  \"field\": {" ;
        string closepointer = blankspace + "  }," ;
        string closefield = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<pointernode<<endl ;
        this->pointer->print(blanks+4) ;
        cout<<closepointer<<endl ;

        cout<<fieldnode<<endl ;
        this->field->print(blanks+4) ;
        cout<<closefield<<endl ;

        cout<<close<<endl ;
    }
};


/*
=============================================================================================================================
*/

// first box inheritence 

// doubt 
class seq_astnode : public statement_astnode{
    public:
    vector<abstract_astnode*> statements_list ;

    seq_astnode(vector<abstract_astnode*> List){
        this->statements_list = List ;
    }

    virtual vector<abstract_astnode*> getseqnodes(){
        return this->statements_list ;
    }
    
    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string rootnode = blankspace + "\"seq\": [" ;
        string open = blankspace + "  {" ;
        string close = blankspace + "  }" ;
        string closenode = blankspace + "]" ;
        int n = statements_list.size() ;
        cout<<rootnode<<endl ;
        string empty = "\"empty\"" ;
        for(int i = 0 ; i < n ; i++){
            if(statements_list[i]->is_empty()){
                this->statements_list[i]->print(blanks+4) ; 
            }
            else{
                cout<<open<<endl ;
                this->statements_list[i]->print(blanks+4) ;
                cout<<close ;       
            }
            if(i != n - 1){
                cout<<","<<endl ; 
            }
        }
        cout<<endl ;
        cout<<closenode<<endl ;
    }
};

class empty_astnode : public statement_astnode{
    public:
    empty_astnode(){

    }
    bool is_empty(){
        return true ;
    }
    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string empty = blankspace + "\"empty\"" ;
        cout<<empty ;
    }
};

class assignS_astnode : public statement_astnode{
    public:
    abstract_astnode* left ;
    abstract_astnode* right ;

    assignS_astnode(abstract_astnode* leftnode, abstract_astnode* rightnode){
        this->left = leftnode ;
        this->right = rightnode ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "\"assignS\": {" ;
        string leftnode = blankspace + "  \"left\": {" ;
        string rightnode = blankspace + "  \"right\": {" ;
        string closeleft = blankspace + "  }," ;
        string closeright = blankspace + "  }" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<leftnode<<endl ;
        this->left->print(blanks+4) ;
        cout<<closeleft<<endl ;

        cout<<rightnode<<endl ;
        this->right->print(blanks+4) ;
        cout<<closeright<<endl ;

        cout<<close<<endl ;

    }
};

class return_astnode : public statement_astnode{
    public:
    abstract_astnode* returnexp ;

    return_astnode(abstract_astnode* rtn){
        this->returnexp = rtn ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace + "\"return\": {" ;
        string close = blankspace + "}" ;

        cout<<rootnode<<endl ;
        this->returnexp->print(blanks+4) ;
        cout<<close<<endl ;
    }
};

class if_astnode : public statement_astnode{
    public:
    abstract_astnode* condition ;
    abstract_astnode* statement1 ;
    abstract_astnode* statement2 ;

    if_astnode(abstract_astnode* a, abstract_astnode* b, abstract_astnode* c){
        this->condition = a ;
        this->statement1 = b ;
        this->statement2 = c ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace +  "\"if\": {" ;
        string condnode = blankspace + "  \"cond\": {" ;
        string condclose = blankspace + "  }," ;
        string close = blankspace + "}" ;
        string thennode = blankspace +  + "  \"then\": {" ;
        string thenclose = blankspace + "  }," ;
        string thenempty = blankspace + "  \"then\": \"empty\"," ;
        string elsenode = blankspace +  + "  \"else\": {" ;
        string elseclose = blankspace + "  }" ;
        string elseempty = blankspace + "  \"else\": \"empty\"" ;

        cout<<rootnode<<endl ;

        cout<<condnode<<endl ;
        this->condition->print(blanks+4) ;
        cout<<condclose<<endl ;

        if(!statement1->is_empty()){
            cout<<thennode<<endl ;
            this->statement1->print(blanks+4) ;
            cout<<thenclose<<endl ;
        }
        else{
            cout<<thenempty<<endl ;
        }

        if(!statement2->is_empty()){
            cout<<elsenode<<endl ;
            this->statement2->print(blanks+4) ;
            cout<<elseclose<<endl ;
        }
        else{
            cout<<elseempty<<endl ;
        }

        cout<<close<<endl ;
    }
};


class for_astnode : public statement_astnode{
    public:
    abstract_astnode* initialisation ;
    abstract_astnode* condition ;
    abstract_astnode* change ;
    abstract_astnode* body ;

    for_astnode(abstract_astnode* a, abstract_astnode* b, abstract_astnode* c, abstract_astnode* d){
        this->initialisation = a ;
        this->condition = b ;
        this->change = c ;
        this->body = d ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace +  "\"for\": {" ;
        string initnode = blankspace + "  \"init\": {" ;
        string initclose = blankspace + "  }," ;
        string guardnode = blankspace + "  \"guard\": {" ;
        string guardclose = blankspace + "  }," ;
        string stepnode = blankspace + "  \"step\": {" ;
        string stepclose = blankspace + "  }," ;
        string bodynode = blankspace + "  \"body\": {" ;
        string bodyclose = blankspace + "  }" ;
        string bodyempty = blankspace + "  \"body\": \"empty\"" ;
        string close = blankspace + "}" ;

        cout<<rootnode<<endl ;

        cout<<initnode<<endl ;
        this->initialisation->print(blanks+4) ;
        cout<<initclose<<endl ;

        cout<<guardnode<<endl ;
        this->condition->print(blanks+4) ;
        cout<<guardclose<<endl ;

        cout<<stepnode<<endl ;
        this->change->print(blanks+4) ;
        cout<<stepclose<<endl ;

        if(!body->is_empty()){
            cout<<bodynode<<endl ;
            this->body->print(blanks+4) ;
            cout<<bodyclose<<endl ;
        }
        else{
            cout<<bodyempty<<endl ;
        }
        cout<<close<<endl ;
    }
};


class while_astnode : public statement_astnode{
    public:
    abstract_astnode* condition ;
    abstract_astnode* body ;
    while_astnode(abstract_astnode* cond, abstract_astnode* statement){
        this->condition = cond ;
        this->body = statement ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;
        string rootnode = blankspace +  "\"while\": {" ;
        string condnode = blankspace + "  \"cond\": {" ;
        string condclose = blankspace + "  }," ;
        string stmtnode = blankspace + "  \"stmt\": {" ;
        string stmtclose = blankspace + "  }" ;
        string stmtempty = blankspace + "  \"stmt\": \"empty\"" ;
        string close = blankspace + "}" ;

        cout<<rootnode<<endl ;

        cout<<condnode<<endl ;
        this->condition->print(blanks+4) ;
        cout<<condclose<<endl ;

        if(!body->is_empty()){
            cout<<stmtnode<<endl ;
            this->body->print(blanks+4) ;
            cout<<stmtclose<<endl ;
        }
        else{
            cout<<stmtempty<<endl ;
        }
        cout<<close<<endl ;
    }
};

class proccall_astnode : public statement_astnode{
    public :
    abstract_astnode *funname ;
    vector<abstract_astnode*> params_list ;

    proccall_astnode(abstract_astnode *name, vector<abstract_astnode*> List){
        this->funname = name ;
        this->params_list = List ;
    }

    virtual void print(int blanks){
        string blankspace = string(blanks, ' ') ;

        string node = blankspace + "  \"proccall\": {" ;
        string rootnode = blankspace + "  \"fname\": {" ; 
        string closenode = blankspace + "  }," ;
        string paramsnode = blankspace + "  \"params\": [" ;
        string paramsclose = blankspace + " ]" ;
        string close = blankspace + "}" ;

        cout<<node<<endl ;

        cout<<rootnode<<endl ;
        this->funname->print(blanks+4) ;
        cout<<closenode<<endl ;

        cout<<paramsnode<<endl ;
        int n = this->params_list.size() ;
        for(int i = 0 ; i < n ; i++){
            cout<<blankspace+"{"<<endl ;
            this->params_list[i]->print(blanks+4) ;
            cout<<blankspace+"}"<<endl ;
            if(i != n -1){
                cout<<","<<endl ;
            }
        }
        cout<<paramsclose<<endl ;

        cout<<close<<endl ;
    }
};
