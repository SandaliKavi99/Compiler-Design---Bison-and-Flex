%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern FILE *yyout;
%}

/*all  tokens*/

%token TOK_MAIN_FUNCTION
%token TOK_OPEN_BRACKET 
%token TOK_CLOSE_BRACKET 
%token TOK_PRINTVAR 
%token TOK_SEMICOLON 
%token TOK_INT 
%token TOK_FLOAT 
%token TOK_ASSIGN 
%token TOK_ID 
%token TOK_DOT
%token TOK_INTNUM 
%token TOK_FLOATNUM

/*all types*/

%union{
int int_value;
float float_value;
struct identifier id;
int line_count;
}

%code requires{
    struct identifier{
        char name[100];
        int type;
        int itegervalue;
        float floatvalue;
        int initialized;
        int line_count;
    };
}

%code{
    struct identifier idArray[100];
    int i = 0;

    struct identifier* checkid(struct identifier id){
        int k;
        for(k = 0; k <= i; k++){
            if(strcmp(idArray[k].name, id.name) == 0){
                return &idArray[k];
            }
        }
        return NULL;
    }

    
}


%start program
%type <id> TOK_ID
%type <int_value> TOK_INTNUM  
%type <float_value> TOK_FLOATNUM
%type <id> E


/*left associative*/
%left TOK_ADD
%left TOK_MUL

%%
program : TOK_MAIN_FUNCTION TOK_OPEN_BRACKET Statements TOK_CLOSE_BRACKET
Statements : | Statement TOK_SEMICOLON Statements ;
Statement : TOK_ID TOK_ASSIGN E
                {
                    
                        struct identifier *id=checkid($1);
                        if(!id)
                        {
                                fprintf(stderr,"Line No %d : %s is used but is not declared\n",$1.line_count,$1.name);
                                return -1;
                        }
                        if(id->type != $3.type){
                                        
                                        fprintf(stderr,"type error : Types are mismatched at line %d\n",$1.line_count);
                                        return -1;
                                }
                                else if(id->type==1)
                                        id->floatvalue=$3.floatvalue;
                                else
                                        id->itegervalue = $3.itegervalue;
                }
            |TOK_INT TOK_ID 
                {
                        struct identifier *id=checkid($2);
                        if(id) // id is already in array
                        {
                                fprintf(stderr,"%s parsing error.\n",id->name);
                                return -1;
                        }
                        i++;
                        idArray[i].type=0; 
                        strcpy(idArray[i].name,$2.name);//copy
                    

                }
            | TOK_FLOAT TOK_ID 
                {
                        struct identifier *id=checkid($2);
                        if(id)
                        {
                                fprintf(stderr,"%s parsing error.\n",id->name);
                                return -1;
                        }
                        i++;
                        idArray[i].type=1; 
                        strcpy(idArray[i].name,$2.name);

                }
            
            | TOK_PRINTVAR TOK_ID {
                struct identifier *id = checkid($2);
                    if(id){
                                if(id->type==0){
                                fprintf(stdout,"%s = %d (int)\n",id->name,id->itegervalue);
                                
                                }
                                else if(id->type==1){
                                fprintf(stdout,"%s = %f (float)\n",id->name,id->floatvalue);
                                }
                                else{
                                        fprintf(stderr,"type error : Type is mismatched at Line No : %d",$2.line_count);
                                        return -1;
                                }
                        }
                    else{
                                fprintf(stderr,"%s Not declared \n",$2.name);
                                return -1;
                        }
            }
E : TOK_ID
        {
            struct identifier *id=checkid($1);
            if(!id)
            {
                fprintf(stderr,"%s is not declared\n",$1.name);
                return -1;
            }
            $$ = *id;
        }
    |TOK_INTNUM
        {
            $$.itegervalue=$1;
            $$.type=0;
        } 
    | TOK_FLOATNUM
        {
            $$.floatvalue=$1;
            $$.type=1;
        }
    
    | E TOK_ADD E
        {
            if($1.type != $3.type){
                fprintf(stderr," type error : Types are mismatched at Line No: %d\n",$1.line_count);
                return -1;
            }
            else if($1.type==1){
                $$.floatvalue=$1.floatvalue+$3.floatvalue;
                $$.type=1;
            }
            else{
                $$.itegervalue=$1.itegervalue+$3.itegervalue;
                $$.type=0;
            }
        }
    | E TOK_MUL E
    {
        if($1.type != $3.type){
            fprintf(stderr," type error : Types are mismatched at Line No: %d\n",$1.line_count);
            return -1;
        }
        else if($1.type==1){
            $$.floatvalue=$1.floatvalue*$3.floatvalue;
            $$.type=1;
        }
        else{
            $$.itegervalue=$1.itegervalue*$3.itegervalue;
            $$.type=0;
        }
    }
%%
int yyerror(char *s){
    fprintf(stdout, "syntax error\n");
    return 0; 
}

int main(int argc, char **argv)
{
   
     if (argc == 2){
        yyin = fopen(argv[1], "r");
    }
    
    else{
        yyin = stdin;
    }
    struct identifier idArray[10000];
    int i=0;
    yyparse();
    yyout = stdout;
    return 0;
}

