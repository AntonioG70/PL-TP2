%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#include <sys/types.h>
#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
extern int yylex();
int yyerror();

void create_HTML(char *str){
  for(int i = 0; str[i] != '\0'; i++){
    if(str[i] == '\n'){
      str[i] = '\0';
      break;
    }
  }
  char file[20];
  sprintf(file, "%s.html", str);
  printf("%s\n", file);
  int fd = open(file, O_CREAT | O_TRUNC | O_WRONLY, 0666);
}

%}

%union{ char* palavra; }

%token IN INITIT INITTRIP txt PONTOVIRGULA VIRG obj
%token <palavra> pal

%%
Anotacao : IN Doc Triplos                {printf("Reconheci comando Anotacao\n");}
         | IN Doc Triplos Anotacao       {printf("Reconheci comando varias Anotacoes\n");}
         ;

Doc : Topico Titulo Texto       {printf("Reconheci doc\n");}
    ;

Topico : pal                      {create_HTML($1); printf("Reconheci topico\n");}
       ;

Titulo : INITIT pal               {printf("Reconheci titulo\n");}
       ;

Texto : pal Texto                 {printf("Reconheci texto\n");}
      | pal
      ;

TriplosList : INITTRIP Sujeito Triplos
            | INITTRIP Sujeito Triplos TriplosList
            ;

Triplos : Relacao ListaObjeto
        ;

ListaObjeto : Objeto PONTOVIRGULA
            | Objeto VIRG ListaObjeto
            ;

Objeto : obj
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
