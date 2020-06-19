%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <math.h>

%}

%token IN INITIT INITTRIP pal

%%
Anotacao : IN Doc Triplos
         ;

Doc : Topico Titulo Texto
    ;

Topico : pal
       ;

Titulo : INITIT pal
       ;

Texto : pal
      ;

Triplos : INITTRIP pal
        ;

%%

#include "lex.yy.c"

int yyerror(char *s) {
    printf("ERRO: %s\n",s);
    return(0);
}

int main(){
    yyparse();
    return 0;
}
