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

%token IN INITIT INITTRIP txt
%token <palavra> pal

%%
Anotacao : IN Doc      {printf("Reconheci comando1\n");}
         ;

Doc : Topico Titulo Texto       {printf("Reconheci comando2\n");}
    ;

Topico : pal                      {create_HTML($1); printf("Reconheci comando3\n");}
       ;

Titulo : INITIT pal               {printf("Reconheci comando4\n");}
       ;

Texto : pal Texto                 {printf("Reconheci comando5\n");}
      | pal
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
