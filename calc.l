%{
    #include <stdio.h>
    #include<string.h>
    #include "calc.tab.h"
    int line_count = 1;
    
%}


%%

"main()" {return(TOK_MAIN_FUNCTION);}
"{" {return(TOK_OPEN_BRACKET);}
"}" {return(TOK_CLOSE_BRACKET);}
"printvar" { return(TOK_PRINTVAR);}
";" { return(TOK_SEMICOLON); }
"+" { return(TOK_ADD); }
"*" { return(TOK_MUL); }
"=" {return(TOK_ASSIGN);}
"." {return(TOK_DOT);}
"int" {return(TOK_INT);}
"float" {return(TOK_FLOAT);}

[0-9]+ {
    yylval.int_value = atoi(yytext);
    return(TOK_INTNUM);
}

[0-9]+"."[0-9]+ {
    yylval.float_value = atoi(yytext);
    return(TOK_FLOATNUM);
}

[a-z][a-z0-9]* {
        strcpy(yylval.id.name, yytext);
        yylval.id.type = 1;
        yylval.id.itegervalue = 1;
        yylval.id.floatvalue = 1.0;
        yylval.id.initialized = 0;
        yylval.id.line_count = line_count;
        return TOK_ID; 
     }
\n {
   line_count++;
    }
[ ] {}
. {}

%%
int yywrap(void) {
return 1;
}
