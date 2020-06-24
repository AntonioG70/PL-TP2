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

%union{ char* palavra; char* objeto;}

%token IN INITIT INITTRIP txt PONTOVIRGULA VIRG SPACE
%token <palavra> pal
%token <objeto> obj
%token <objeto> suj

%%
Anotacao : IN Doc Triplos                {printf("YACC:Reconheci comando Anotacao\n");}
         | IN Doc Triplos Anotacao       {printf("YACC:Reconheci comando varias Anotacoes\n");}
         ;

Doc : Topico Titulo Texto       {printf("YACC:Reconheci doc\n");}
    ;

Topico : pal                      {create_HTML($1); printf("YACC:Reconheci topico\n");}
       ;

Titulo : INITIT pal               {printf("YACC:Reconheci titulo\n");}
       ;

Texto : pal Texto                 {printf("YACC:Reconheci texto\n");}
      | pal
      ;

Triplos : INITTRIP TriplosList          {printf("YACC:Reconheci triplos\n");}
        ;

TriplosList : Sujeito SPACE Relacoes          {printf("YACC:Reconheci triploList\n");}
            | Sujeito SPACE Relacoes TriplosList      {printf("YACC:Reconheci triploList com triploList\n");}
            ;

Relacoes : Relacao SPACE ListaObjeto              {printf("YACC:Reconheci Relacoes:\n");}
         | Relacao SPACE ListaObjeto SPACE Relacoes     {printf("YACC:Reconheci Relacoes com Relacoes:\n");}
         ;

Relacao : obj               {printf("YACC:Reconheci Relacao\n");}
        ;

ListaObjeto : Objeto PONTOVIRGULA         {printf("YACC:Reconheci Lista objeto\n");}
            | Objeto VIRG SPACE ListaObjeto     {printf("YACC:Reconheci Lista objeto com lista objeto\n");}
            ;

Sujeito : suj             {printf("YACC:Reconheci sujeito %s\n", $1);}
        ;

Objeto : obj              {printf("YACC:Reconheci objeto\n");}
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
