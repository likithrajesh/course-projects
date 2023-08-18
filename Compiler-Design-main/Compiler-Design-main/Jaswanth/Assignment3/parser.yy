%skeleton "lalr1.cc"
%require  "3.0.1"

%defines 
%define api.namespace {IPL}
%define api.location.type{IPL::location}
%define api.parser.class {Parser}

%define parse.trace

%code requires{
  #include "ast.hh"
  #include "symtab.hh"
  #include "type.hh"
  #include "location.hh"
   namespace IPL { 
      class Scanner;
   }

  // # ifndef YY_NULLPTR
  // #  if defined __cplusplus && 201103L <= __cplusplus
  // #   define YY_NULLPTR nullptr
  // #  else
  // #   define YY_NULLPTR 0
  // #  endif
  // # endif

}
%printer { cerr << $$; } STRING_LITERAL
%printer { cerr << $$; } IDENTIFIER
%printer { cerr << $$; } STRUCT
%printer { cerr << $$; } VOID
%printer { cerr << $$; } IF
%printer { cerr << $$; } ELSE
%printer { cerr << $$; } WHILE
%printer { cerr << $$; } FOR
%printer { cerr << $$; } INT_CONSTANT
%printer { cerr << $$; } FLOAT_CONSTANT
%printer { cerr << $$; } INT
%printer { cerr << $$; } FLOAT
%printer { cerr << $$; } RETURN
%printer { cerr << $$; } LE_OP
%printer { cerr << $$; } GE_OP
%printer { cerr << $$; } EQ_OP
%printer { cerr << $$; } NE_OP
%printer { cerr << $$; } OR_OP
%printer { cerr << $$; } AND_OP
%printer { cerr << $$; } INC_OP
%printer { cerr << $$; } PTR_OP
%printer { cerr << $$; } OTHERS



%parse-param { Scanner  &scanner  }
%locations
%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   #include <string>
   #include <cstring>
   #include <map>
   
   
   #include "scanner.hh"
   vector<varinfo*> vars ;
   localsymboltable *lsymtable ;
   globalsymboltable *gsymtable ;
   map<string, varinfo*> globalmap ;
   map<string, vector<varinfo*>> structlsymtable ; 
   map<string, vector<varinfo*>> functionlsymtab ;
   map<string, abstract_astnode*> astfuncmap ;
   map<string, vector<varinfo*>> params ;
  string retype;


#undef yylex
#define yylex IPL::Parser::scanner.yylex

}




%define api.value.type variant
%define parse.assert

%start new_start




%token <string> STRING_LITERAL
%token <string> IDENTIFIER
%token <string> STRUCT
%token <string> VOID 
%token <string> IF 
%token <string> ELSE 
%token <string> WHILE 
%token <string> FOR
%token <string> INT_CONSTANT
%token <string> FLOAT_CONSTANT
%token <string> INT
%token <string> FLOAT
%token <string> RETURN
%token <string> LE_OP
%token <string> GE_OP
%token <string> EQ_OP
%token <string> NE_OP
%token <string> OR_OP
%token <string> AND_OP
%token <string> INC_OP
%token <string> PTR_OP
%token <string> OTHERS
%token <string> EOFILE
%token '{' '}' ';' '*' '(' ')' ',' '[' ']' '=' '>' '<' '+' '-' '/' '.' '!' '&' ':' '"'

%nterm <abstract_astnode*> new_start translation_unit struct_specifier function_definition compound_statement statement_list statement assignment_expression assignment_statement procedure_call expression logical_and_expression equality_expression relational_expression additive_expression unary_expression multiplicative_expression postfix_expression primary_expression selection_statement iteration_statement 
<string> unary_operator fun_declarator type_specifier
<vector<varinfo*>> declaration_list declarator_list declaration parameter_list
<varinfo*> declarator declarator_arr parameter_declaration
<vector<abstract_astnode*>> expression_list
%%

new_start:
  translation_unit
  {
    string start = "{\"globalST\":" ;
    cout<<start<<endl ;
    cout<<"[" ;
    auto it = globalmap.begin() ;
    int i = 1 ;
    while(it != globalmap.end()){
      gsymtable = new globalsymboltable(it->second) ;
      gsymtable->display_varinfo() ;
      it++ ;
      if(it != globalmap.end()){
        cout<<","<<endl ;
      }
      i++ ;
    }
    cout<<endl ;
    cout<<"]"<<endl ;
    cout<<","<<endl ;

    string Structs = " \"structs\": [" ;
    cout<<Structs<<endl ;

    auto it2 = structlsymtable.begin() ;
    i = 1 ;
    int size = 0 ;
    while(it2 != structlsymtable.end()){
      cout<<"{"<<endl ;
      map<string, varinfo*> temp ;
      size = it2->second.size() ;
      for(int j = 0 ; j < size ; j++){
        temp.insert({it2->second[j]->name, it2->second[j]}) ;
      }
      cout<<"\"name\": \"" + it2->first<<"\","<<endl ;
      cout<<"\"localST\":"<<endl ;
      cout<<"["<<endl ;
      auto it3 = temp.begin() ;
      while(it3 != temp.end()){
        lsymtable = new localsymboltable(it3->second) ;
        lsymtable->display_varinfo() ;
        it3++ ;
        if(it3 != temp.end()){
          cout<<endl ;
          cout<<","<<endl ;
        }
      }
      i++ ;
      it2++ ;
      cout<<endl ;
      cout<<"]"<<endl ;
      cout<<"}" ;
      if(it2 != structlsymtable.end()){
        cout<<endl ;
        cout<<","<<endl ;
      }
    }
    cout<<endl ;
    cout<<"],"<<endl ;


    cout<<" \"functions\": ["<<endl ;
    auto it4 = functionlsymtab.begin() ;
    int k = 0 ;
    while(it4 != functionlsymtab.end()){
      cout<<"{"<<endl ;
      map<string, varinfo*> temp ;
      k = it4->second.size() ;
      for(int j = 0 ; j < k ; j++){
        temp.insert({it4->second[j]->name, it4->second[j]}) ;
      }
      cout<<"\"name\": \"" + it4->first<<"\","<<endl ;
      cout<<"\"localST\":"<<endl ;
      cout<<"["<<endl ;
      auto it5 = temp.begin() ;
      while(it5 != temp.end()){
        lsymtable = new localsymboltable(it5->second) ;
        lsymtable->display_varinfo() ;
        it5++ ;
        if(it5 != temp.end()){
          cout<<","<<endl ;
        }
      } 
      cout<<endl ;
      cout<<"]"<<endl ;
      cout<<","<<endl ; 
      string aststring = "\"ast\": {" ;
      cout<<aststring<<endl ;
      abstract_astnode* node = new seq_astnode(astfuncmap[it4->first]->getseqnodes()) ; 
      node->print(0) ;
      cout<<"}"<<endl ;
      cout<<"}" ; 
      it4++ ;
      if(it4 != functionlsymtab.end()){
        cout<<","<<endl ;
      }
    }
    cout<<endl ;
    cout<<"]"<<endl ;
    cout<<"}"<<endl ;
  }

translation_unit: 
    struct_specifier
    {

    } 
  |  function_definition 
  {

  }
  | translation_unit struct_specifier 
  {

  }
  | translation_unit function_definition 
  {

  }
  ;

struct_specifier:
    STRUCT IDENTIFIER '{' declaration_list '}' ';'     
    {
      vector<varinfo*> temp = $4 ;
      int n = temp.size() ;
      temp[0]->offset = 0 ;
      int i = 0 ;
      string var = "var" ;
      string lscope = "local" ;
      string gscope = "global" ;
      while(i < n){
        $4[i]->type = var ;
        $4[i]->scope = lscope ;
        if(i >= 1){
          temp[i]->offset = temp[i-1]->offset + temp[i-1]->size ;
        }
        i++ ;
      }  
      string name = "struct " + $2 ;
      structlsymtable.insert({name, $4}) ;
      vars.clear() ;
      varinfo* entry = new varinfo(name,"struct",gscope,temp[n-1]->size + temp[n-1]->offset, 0, "-") ;
      globalmap.insert({name, entry}) ;
    } 
    ;


function_definition:  
    type_specifier { retype = $1; }  fun_declarator compound_statement
    {
      if(functionlsymtab.find($3) != functionlsymtab.end()){
        int i = 0 ;
        int size = vars.size() ;
        while(i < size){
          functionlsymtab[$3].push_back(vars[i]) ;
          i++ ;
        }
        vars.clear() ;
      }
      else{
        functionlsymtab.insert({$3, vars}) ;
        vars.clear() ;
      }
      globalmap[$3]->datatype = $1 ;
      $$ = $4 ;
      astfuncmap.insert({$3, $$}) ;
    }
    ;
    
type_specifier:
    VOID
    {
      $$ = $1 ;
    }

  | INT 
  {
    $$ = $1 ;
  }
  | FLOAT 
  {
    $$ = $1 ;
  }
  | STRUCT IDENTIFIER 
  {
    $$ = $1 + " " + $2 ;      
  }
  ;

fun_declarator: 
    IDENTIFIER '(' parameter_list ')'  
    {
      if(functionlsymtab.find($1) != functionlsymtab.end()){
        int i = 0;
        int size = $3.size() ;
        while(i < size){
          functionlsymtab[$1].push_back($3[i]) ;
          i++ ;
        }
      }
      else{
        functionlsymtab.insert({$1, $3}) ;
      }
      vector<varinfo*> temp ;
      int n = $3.size() ;
      int j = 0 ;
      while(j < n){
        vars.push_back($3[j]) ;
        temp.push_back($3[j]) ;
        j++ ;
      }
      varinfo* entry = new varinfo($1, "fun", "global", 0, 0, "-") ;
      globalmap.insert({$1, entry}) ;
      params.insert({$1, temp}) ;
      $$ = $1 ;
    }
  | IDENTIFIER '(' ')' 
  {
    varinfo* entry = new varinfo($1, "fun", "global", 0, 0, "-") ;
    globalmap.insert({$1, entry}) ;
    vector<varinfo*> temp ;
    params.insert({$1, temp}) ;
    $$ = $1 ;
  }
  ;

parameter_list:
    parameter_declaration 
    {
      vector<varinfo*> temp ;
      temp.push_back($1) ;
      $$ = temp ;
    }
  | parameter_list ',' parameter_declaration    
  {
    vector<varinfo*> temp = $1 ;
    varinfo* temp1 = $3 ;
    int i = 0 ;
    int n = temp.size() ;
    while(i < n){
      temp[i]->offset += temp1->size ; 
      i++ ;
    }
    temp.push_back(temp1) ;
    $$ = temp ;
  }    
  ; 

parameter_declaration:
    type_specifier declarator 
    {
      varinfo* entry = $2 ;
      string gettype = $1.substr(0, 6) ;
      if(gettype == "struct"){
        if(entry->datatype[0] == '['){
          entry->size *= globalmap[$1]->size ; 
        }
        else if(entry->datatype == ""){
          entry->size = globalmap[$1]->size ;
        }
        else if(entry->datatype[0] == '*'){
          ; 
        }
      }
      else{
        if(entry->datatype[0] == '*'){
          ;
        }
        else if(entry->datatype[0] == '['){
          entry->size = 4*entry->size ;
        }
        else if(entry->datatype == ""){
          entry->size = 4 ;
        }
      }
      entry->datatype = $1 + entry->datatype ;
      entry->type = "var" ;
      entry->scope = "param" ;
      entry->offset = 12 ;
      $$ = entry ;
    } 
    ;

declarator_arr: 
     IDENTIFIER
     {
       varinfo* entry = new varinfo($1, "", "", 0, 0, "") ;
       $$ = entry ;
     }       
     | declarator_arr '[' INT_CONSTANT ']'  
     {
       varinfo* entry = $1 ;
       entry->datatype = entry->datatype + "[" + $3 + "]" ;
       if(entry->size != 0){
         entry->size = entry->size*stoi($3) ;
       }
       else{
         entry->size = stoi($3) ;
       }
       $$ = entry ;
     }

declarator:
     declarator_arr
     {
       $$ = $1 ;
     }
     | '*' declarator
     {
       varinfo* entry = $2 ;
       if(entry->datatype == ""){
         entry->size = 4 ;
       }
       else if(entry->datatype[0]== '['){
         entry->size = 4*entry->size ;
       }
       else if(entry->datatype[0] == '*'){
         ;
       }
       char temp = '*' ;
       entry->datatype = temp + entry->datatype ;
       $$ = entry ;
     }
     ;

compound_statement: 
    '{' '}' 
    {
      vector<abstract_astnode*> temp ;
      $$ = new seq_astnode(temp) ;

    }
  | '{' statement_list '}' 
  {
    $$ = $2 ;
  }
  | '{' declaration_list '}' 
  {
    vector<varinfo*> temp = $2 ;
    int val = 0 ;
    int i = 0 ;
    int n = temp.size() ;
    string var = "var" ;
    string lscope = "local" ;
    while(i < n){
      temp[i]->type = var ;
      temp[i]->scope = lscope ;
      val = val - temp[i]->size ;
      temp[i]->offset = val ;
      i++ ;
    }
    vector<abstract_astnode*> temp1 ;
    $$ = new seq_astnode(temp1) ;
  }
  | '{' declaration_list statement_list '}'
  {
    vector<varinfo*> temp = $2;
    int size = 0 ;
    int i = 0 ;
    int n = temp.size() ;
    string var = "var" ;
    string lscope = "local" ;
    while(i < n){
      temp[i]->type = var ;
      temp[i]->scope = lscope ;
      size = size - temp[i]->size ;
      temp[i]->offset = size ;
      i++ ;
    }
    $$ = $3 ;
  }
  ;

statement_list:
    statement
    {
      vector<abstract_astnode*> temp ;
      temp.push_back($1) ;
      $$ = new seq_astnode(temp) ;

    }   
  | statement_list statement  
  {
    vector<abstract_astnode*> temp ;
    temp = $1->getseqnodes() ;
    temp.push_back($2) ;
    $$ = new seq_astnode(temp) ;
  }
  ;

statement:
      ';'  
      {
        $$ = new empty_astnode() ;
      }
    |  '{' statement_list '}'
    {
      $$ = $2 ;

    } 
    | selection_statement 
    {
      $$ = $1 ;
    }  
    | iteration_statement
    {
      $$ = $1 ;
    }  
    | assignment_statement  
    {
      $$ = $1 ;
    }
    | procedure_call  
    {
      $$ = $1 ;
    }      
    | RETURN expression ';' 
    {
      string returntype = $2->node->datatype ;
      string final = "TO_" ;
      if(retype == "int"){
        if(returntype == "float"){
          final = final + "INT" ;
          $2 = new op_unary_astnode(final, $2) ;
        }
      }
      if(retype == "float"){
        if(returntype == "int"){
          final = final + "FLOAT" ;
          $2 = new op_unary_astnode(final, $2) ;
        }
      }
      $$ = new return_astnode($2) ;
    } 
    ;


assignment_expression:
     unary_expression '=' expression 
     {
       if($3->node->datatype == "int" && ($3->node->ptr == 0) && ($3->node->indices.size() == 0)){
         if($1->node->datatype == "float" && ($1->node->ptr == 0) && ($1->node->indices.size() == 0)){
           string op = "TO_FLOAT" ;
           $3 = new op_unary_astnode(op, $3) ;
         }
       }
       if($1->node->datatype == "int" && ($1->node->ptr == 0) && ($1->node->indices.size() == 0)){
         if($3->node->datatype == "float" && ($3->node->ptr == 0) && ($3->node->indices.size() == 0)){
           string op = "TO_FLOAT" ;
           $1 = new op_unary_astnode(op, $1) ;
         }
       }
       $$ = new assignE_astnode($1, $3) ;
     }
     ;

assignment_statement: 
    assignment_expression ';'
    {
      abstract_astnode* param1 = $1->getleftnode();
      abstract_astnode* param2 = $1->getrightnode();
      $$ = new assignS_astnode(param1, param2) ;
    } 
    ;

procedure_call:
     IDENTIFIER '(' ')' ';'
     {
       if($1 == "scanf" || $1 == "printf" || $1 == "mod"){

       } 
       else{
         if(globalmap.find($1) != globalmap.end()){
           if(params[$1].size() != 0){
             string error_message = "There are no arguments for the function call defined, but u are providing arguments" ;
             error(@$, error_message) ;
           }
         }
         else{
           string error_message = "procedural call to the function which u are accessing is not declared" ;
           error(@$, error_message) ;
         }
       }
       vector<abstract_astnode*> temp ;
       $$ = new proccall_astnode(new identifier_astnode($1),temp);
     }
     | IDENTIFIER '(' expression_list ')' ';'
    {
      if($1 == "scanf" || $1 == "printf" || $1 == "mod"){

      }
      else{
        if(globalmap.find($1) != globalmap.end()){
          if(params[$1].size() != $3.size()){
            string error_message = "Insufficient arguments : number of parameters given are not matching with the number of parameters required for the function" ;
            error(@$, error_message) ;
          }
          else{
            bool possible ;
            int n = $3.size() ;
            int i = 0 ;
            while(i < n){
              TypeTree *node1 = $3[i]->node ;
              TypeTree *node2 = new TypeTree(params[$1][i]->datatype) ;
              possible = iscompatible(node1, node2) ;
              if(!possible){
                string error_message = "parameters type is not consistent" ;
                error(@$, error_message) ;
              }
              else if(possible && node1->datatype == "struct" && node2->datatype == "struct"){
                ;
              }
              else if(possible && (node1->datatype == "void" || node2->datatype == "void")){
                ;
              }
              else{
                string final = cast(node1, node2) ;
                string op = "TO_" ;
                if(final != ""){
                  op = op + final ;
                  $3[i] = new op_unary_astnode(op, $3[i]) ;
                }
              }
              i++ ;
            }
          }
        }
        else{
          string error_message = $1 +" function has not been declared" ;
          error(@$, error_message) ;
        }
      }
      $$ = new proccall_astnode(new identifier_astnode($1), $3) ;
    } 
    ;

expression:
    logical_and_expression 
    {
      $$ = $1 ;
    }
  | expression OR_OP logical_and_expression 
  {
    if($1->node->datatype == "struct" || $3->node->datatype == "struct"){
      string error_message = "operand of && should be scalar" ;
      error(@$, error_message) ;
    }
    string op = "OR_OP" ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  }
  ;

logical_and_expression:
    equality_expression
    {
      $$ = $1 ;
    }
  | logical_and_expression AND_OP equality_expression 
  {
    if($1->node->datatype == "struct" || $3->node->datatype == "struct"){
      string error_message = "operand of && should be scalar" ;
      error(@$, error_message) ;
    }
    string op = "AND_OP" ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  }
  ;


equality_expression :
    relational_expression
    {
      $$ = $1 ;
    } 
  | equality_expression EQ_OP relational_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "EQ_OP_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;   
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ; 
  }
  | equality_expression NE_OP relational_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "NE_OP_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  }
  ;

relational_expression:
    additive_expression 
    {
      $$ = $1 ;
    }
  | relational_expression '<' additive_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "LT_OP_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  }
  | relational_expression '>' additive_expression  
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "GT_OP_"+ final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  }
  | relational_expression LE_OP additive_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "LE_OP_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  } 
  | relational_expression GE_OP additive_expression
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "GE_OP_" + final;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->node = new TypeTree("int") ;
    $$->lvalue = false ;
  } 
  ;

additive_expression:
    multiplicative_expression 
    {
      $$ = $1 ;
    }
  | additive_expression '+' multiplicative_expression
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float" ) && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "PLUS_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->lvalue = false ;
    if(final == "INT"){
      final = "int" ;
    }
    else{
      final = "float" ;
    }
    $$->node = new TypeTree(final) ;
  }
  | additive_expression '-' multiplicative_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "MINUS_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->lvalue = false ;
    string var = "float" ;
    if(final == "INT"){
      var = "int" ;
    }
    $$->node = new TypeTree(var) ;
  } 
  ;

unary_expression:
    postfix_expression 
    {
      $$ = $1 ;
    }
  | unary_operator unary_expression 
  {
    $$ = new op_unary_astnode($1, $2) ;

    if($1 == "UMINUS"){
      string error_message = "invalid operands" ;
      if($2->node->datatype == "int" || $2->node->datatype == "float"){
        if($2->node->indices.size() == 0 && $2->node->ptr == 0){

        }
        else{
          error(@$, error_message) ;
        }
        $$->node = $2->node ;
        $$->lvalue = false ;
      }
      else{
        error(@$, error_message) ;
      }
    }
    else if($1 == "NOT"){
      string error_message = "invalid operands" ;
      if($2->node->datatype == "struct"){
        if($2->node->ptr == 0 && $2->node->indices.size() == 0){
          error(@$, error_message) ;
        }
      }
      $$->node = new TypeTree("int") ;
      $$->lvalue = false ;
    }
    else if($1 == "ADDRESS"){
      string error_message = "invalid operands" ;
      if(!$2->lvalue){
        error(@$, error_message) ;
      }
      $$->node = $2->node ;
      $$->node->ptr = $$->node->ptr + 1 ;
      $$->lvalue = false ;
    }
    else{
      TypeTree *post_node = $2->node ;
      if((post_node->ptr == 0) && (post_node->indices.size() == 0)){
        string error_message = "invalid operands" ;
        error(@$, error_message) ;
      }
      $$->node = new TypeTree(post_node) ;
      if($$->node->indices.size() > 0){
        vector<int> temp = $$->node->indices ;
        int i = 0 ;
        int size = temp.size() ;
        $$->node->indices.clear() ;
        while(i < size){
          if(i != 0){
            $$->node->indices.push_back(temp[i]) ;
          }
          i++ ;
        }
      }
      else{
        $$->node->ptr = $$->node->ptr -1 ; 
      }
      $$->lvalue = true ;      
    }
  }
  ;

multiplicative_expression:
     unary_expression 
     {
       $$ = $1 ;
     } 
     | multiplicative_expression '*' unary_expression 
    {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
        if(($1->node->ptr > 0) || ($3->node->ptr > 0) || ($1->node->indices.size() > 0) || ($3->node->indices.size() > 0)){
          string error_message = "invalid operands" ;
          error(@$, error_message) ;  
        }
        else{
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
        }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "MULT_" + final;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->lvalue = false ;
    string var = "float" ;
    if(final == "INT"){
      var = "int" ;
    }
    $$->node = new TypeTree(var) ;
    }
  | multiplicative_expression '/' unary_expression 
  {
      string final = "" ;
      if(($1->node->datatype == "int" || $1->node->datatype == "float") && ($3->node->datatype == "int" || $3->node->datatype == "float")){
        if(($1->node->ptr > 0) || ($3->node->ptr > 0) || ($1->node->indices.size() > 0) || ($3->node->indices.size() > 0)){
          string error_message = "invalid operands" ;
          error(@$, error_message) ;  
        }
        else{
          if($1->node->datatype == "int" && $3->node->datatype == "int"){
            final = "INT" ;
          }
          else{
            final = "FLOAT" ;
            if($1->node->datatype == "int"){
              $1 = new op_unary_astnode("TO_FLOAT", $1) ;
            }
            if($3->node->datatype == "int"){
              $3 = new op_unary_astnode("TO_FLOAT", $3) ;
            }
          }
        }
      }
      else{
        string error_message = "invalid operands" ;
        error(@$, error_message) ; 
      }
    string op = "DIV_" + final ;
    $$ = new op_binary_astnode(op, $1, $3) ;
    $$->lvalue = false ;
    string var = "float" ;
    if(final == "INT"){
      var = "int" ;
    }
    $$->node = new TypeTree(var) ;
  }  
  ;

postfix_expression: 
    primary_expression 
    {
      $$ = $1 ;
    }
    | postfix_expression '[' expression ']'
    {
      $$ = new arrayref_astnode($1, $3) ;
      TypeTree *exp_node = $3->node ;
      if(exp_node->datatype != "int"){
        string error_message = "array index must be integer" ;
        error(@$, error_message) ;
      }
      TypeTree *post_node = $1->node ;
      if((post_node->ptr == 0) && (post_node->indices.size() == 0)){
        string error_message = "subscripted value neither array nor pointer" ;
        error(@$, error_message) ;
      }
      $$->node = new TypeTree(post_node) ;
      if($$->node->indices.size() > 0){
        vector<int> temp = $$->node->indices ;
        int i = 0 ;
        int size = temp.size() ;
        $$->node->indices.clear() ;
        while(i < size){
          if(i != 0){
            $$->node->indices.push_back(temp[i]) ;
          }
          i++ ;
        }
      }
      else{
        $$->node->ptr = $$->node->ptr -1 ; 
      }
      $$->lvalue = true ;
    }
  | IDENTIFIER '(' ')' 
  {
    string returntype = "" ;
    if(globalmap.find($1) != globalmap.end()){
      returntype = globalmap[$1]->datatype ;
      if(params[$1].size() != 0){
        string error_message = "Insufficient arguments : number of parameters given are not matching with the number of parameters required for the function" ;
        error(@$, error_message) ;
      }
    }
    else{
      string error_message = $1 +" function has not been declared" ;
      error(@$, error_message) ;
    }
    vector<abstract_astnode*> temp ;
    $$ = new funcall_astnode(new identifier_astnode($1),temp);
    $$->node = new TypeTree(returntype) ;

  }
  | IDENTIFIER '(' expression_list ')'
  {
    string returntype = "" ;
    if(globalmap.find($1) != globalmap.end()){
      returntype = globalmap[$1]->datatype ;
      if(params[$1].size() != $3.size()){
        string error_message = "Insufficient arguments : number of parameters given are not matching with the number of parameters required for the function" ;
        error(@$, error_message) ;
      }
      else{
        bool possible ;
        int n = $3.size() ;
        int i = 0 ;
        while(i < n){
          TypeTree *node1 = $3[i]->node ;
          TypeTree *node2 = new TypeTree(params[$1][i]->datatype) ;
          possible = iscompatible(node1, node2) ;
          if(!possible){
            string error_message = "inconsistent types of parameters " ;
            error(@$, error_message) ;
          }
          else if(possible && node1->datatype == "struct" && node2->datatype == "struct"){
            ;
          }
          else if(possible && (node1->datatype == "void" || node2->datatype == "void")){
            ;
          }
          else{
            string final = cast(node1, node2) ;
            string op = "TO_" ;
            if(final != ""){
              op = op + final ;
              $3[i] = new op_unary_astnode(op, $3[i]) ;
            }
          }
          i++ ;
        }
      }
    }
    else{
      string error_message = $1 +" function has not been declared" ;
      error(@$, error_message) ;
    }
    $$ = new funcall_astnode(new identifier_astnode($1),$3);
    $$->node = new TypeTree(returntype) ;
  } 
  | postfix_expression '.' IDENTIFIER
  {
    identifier_astnode* temp = new identifier_astnode($3) ;
    $$ = new member_astnode($1, temp) ;

    TypeTree *post_node = $1->node ;
    if(post_node->datatype != "struct"){
      string error_message = "left operand is not of type struct" ;
      error(@$, error_message) ;
    }
    else if((post_node->ptr >= 1) || (post_node->indices.size() >= 1)){
      string error_message = "left operand is not of type struct pointer" ;
      error(@$, error_message) ;
    }
    else{
      string structname = "struct " + post_node->structname ;
      string error_message = $3 + " is not defined in the " + structname ;
      string check = "" ;
      int i = 0 ;
      int size = structlsymtable[structname].size() ;
      string vardatatype = "" ;
      while(i < size){
        if(structlsymtable[structname][i]->name == $3){
          check = $3 ;
          vardatatype = structlsymtable[structname][i]->datatype ;
          $$->node = new TypeTree(vardatatype) ;
          break ;
        }
        i++ ;
      }
      if(check == ""){
        error(@$, error_message) ;
      }
    }
    $$->lvalue = true ;
  } 
  | postfix_expression PTR_OP IDENTIFIER
  {
    identifier_astnode* temp = new identifier_astnode($3) ;
    $$ = new arrow_astnode($1, temp) ;
    TypeTree *post_node = $1->node ;
    if(post_node->datatype != "struct"){
      string error_message = "left operand is not of type struct" ;
      error(@$, error_message) ;
    }
    else if((post_node->ptr + post_node->indices.size() != 1)){
      string error_message = "left operand is not of type struct pointer" ;
      error(@$, error_message) ;
    }
    else{
      string structname = "struct " + post_node->structname ;
      string error_message = $3 + " is not defined in the " + structname ;
      string check = "" ;
      int i = 0 ;
      int size = structlsymtable[structname].size() ;
      string vardatatype = "" ;
      while(i < size){
        if(structlsymtable[structname][i]->name == $3){
          check = $3 ;
          vardatatype = structlsymtable[structname][i]->datatype ;
          $$->node = new TypeTree(vardatatype) ;
          break ;
        }
        i++ ;
      }
      if(check == ""){
        error(@$, error_message) ;
      }    
    }
    $$->lvalue = true ;
  }
  | postfix_expression INC_OP
  {
    $$ = new op_unary_astnode("PP", $1) ;
    string error_message = "operand of increment should be int, float or pointer" ;
    if($1->node->indices.size() != 0){
      error(@$, error_message) ;
    }
    else if($1->node->ptr != 0){

    }
    if(($1->node->datatype == "int") || ($1->node->datatype == "float") ){
    }
    else{
      error(@$, error_message) ;
    }
    $$->node = $1->node ;
    $$->lvalue = false ;
  }
  ;

primary_expression:
     IDENTIFIER 
     {
       $$ = new identifier_astnode($1) ;
       int n = vars.size() ;
       string datatype = "" ;
       for(int i = 0 ; i < n ; i++){
         if(vars[i]->name == $1){
           datatype = vars[i]->datatype ;
           break ;
         }
       } 
       if(datatype == ""){
         string error_message = $1 + " variable not declared in this scope" ;
         error(@$, error_message) ;
       }
       else{
         $$->node = new TypeTree(datatype) ;
       }
       $$->lvalue = true ;
     }
    
     | INT_CONSTANT 
  {
    $$ = new intconst_astnode($1) ;
    string datatype = "int" ;
    $$->node = new TypeTree(datatype) ;
    $$->lvalue = false ;
  }
     | FLOAT_CONSTANT 
  {
    $$ = new floatconst_astnode($1) ;
    string datatype = "float" ;
    $$->node = new TypeTree(datatype) ;
    $$->lvalue = false ;
  }
     | STRING_LITERAL
  {
    $$ = new stringconst_astnode($1) ;
    string datatype = "string" ;
    $$->node = new TypeTree(datatype) ;
    $$->lvalue = false ;
  }
     | '(' expression ')' 
  {
    $$ = $2 ;
  } 
  ;

expression_list: 
    expression 
    {
      vector<abstract_astnode*> temp ;
      temp.push_back($1) ;
      $$ = temp ;    
    }
  | expression_list ',' expression 
  {
    vector<abstract_astnode*> temp = $1 ;
    temp.push_back($3) ;
    $$ = temp ;
  }
  ;

unary_operator:
    '-' 
    {
      string op = "UMINUS" ;
      $$ = op ;
    }
  | '!'  
  {
    string op = "NOT" ;
    $$ = op ;
  }
  | '&' 
  {
    string op = "ADDRESS" ;
    $$ = op ;
  }
  | '*'
  {
    string op = "DEREF" ;
    $$ = op ;
  }
  ;
  
selection_statement: 
    IF '(' expression ')' statement ELSE statement 
    { 
      abstract_astnode* param1 = $3 ;
      abstract_astnode* param2 = $5 ;
      abstract_astnode* param3 = $7 ;
      $$ = new if_astnode(param1, param2, param3) ;

    }
    ;
    
iteration_statement: 
    WHILE '(' expression ')' statement 
    {
      abstract_astnode* param1 = $3 ;
      abstract_astnode* param2 = $5 ;
      $$ = new while_astnode(param1, param2) ;

    }
  | FOR '(' assignment_expression ';' expression ';' assignment_expression ')' statement 
  {
      abstract_astnode* param1 = $3 ;
      abstract_astnode* param2 = $5 ;
      abstract_astnode* param3 = $7 ;
      abstract_astnode* param4 = $9 ;
      $$ = new for_astnode(param1, param2, param3, param4) ;

  }
  ;

declaration_list: 
    declaration 
    {
      vector<varinfo*> temp = $1 ; 
      int size = temp.size() ;
      for(int i = 0 ; i < size ; i++){
        vars.push_back(temp[i]) ;
      }
      $$ = $1 ;
    }
  | declaration_list declaration 
  {
    vector<varinfo*> temp1 = $1; 
    vector<varinfo*> temp2 = $2 ;
    int m = temp2.size() ;
    int i = 0 ;
    while(i < m){
      temp1.push_back(temp2[i]) ;
      vars.push_back(temp2[i]) ;
      i++ ;
    } 
    $$ = temp1 ;
  }
  ;

declaration:
    type_specifier declarator_list ';' 
    {
      vector<varinfo*> temp = $2 ;
      int size = temp.size() ;
      int i = 0 ;
      string gettype = $1.substr(0, 6) ;
      while(i < size){
        if(gettype == "struct"){
          if(temp[i]->datatype[0]  == '['){
            temp[i]->size *= globalmap[$1]->size ;
          }
          else if(temp[i]->datatype == ""){
            temp[i]->size = globalmap[$1]->size ;
          }
          else if(temp[i]->datatype[0] == '*'){
            ;
          }
        }
        else{
          if(temp[i]->datatype[0] == '*'){
          }
          else if(temp[i]->datatype == ""){
            temp[i]->size = 4 ;
          }
          else if(temp[i]->datatype[0] == '['){
            temp[i]->size = 4*temp[i]->size ;
          }
        }
        temp[i]->datatype = $1 + temp[i]->datatype ;
        i++ ;
      }
      $$ = temp ;
      int n = temp.size() ;
      int j = 0 ;
      while(j < n){
        if(temp[j]->datatype == "void"){
          string error_message = "we can not declare variable type of void" ;
          error(@$, error_message) ;
        }
        j++ ;
      }
    }
    ;

declarator_list:
    declarator 
    {
      vector<varinfo*> temp ;
      temp.push_back($1) ;
      $$ = temp ;
    }
  | declarator_list ',' declarator 
  {
    vector<varinfo*> temp ;
    temp = $1 ;
    temp.push_back($3) ;
    $$ = temp ;
  }
  ;

%%
void IPL::Parser::error( const location_type &l, const string &err_message )
{
  cout<< "Error at line " << l.begin.line<<": "<< err_message <<"\n";
  exit(1) ;
}


