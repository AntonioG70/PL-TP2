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

char *currentHTML;
char* currentSujeito;
char* currentRelacao;


void create_HTML(char *str){
  for(int i = 0; str[i] != '\0'; i++){
    if(str[i] == '\n'){
      str[i] = '\0';
      break;
    }
  }
  currentHTML = strdup(str);
  char file[80];
  int count_bytes = 0;
  sprintf(file, "%s.html", str);
  printf("%s\n", file);
  int fd = open(file, O_CREAT | O_TRUNC | O_WRONLY | O_APPEND, 0666);
  char *buf = "<!DOCTYPE html>\n<html>\n<body>\n";
  char string[30];
  count_bytes = sprintf(string,"<h1>%s</h1>\n", str);
  printf("VOU ESCREVER: %s COUNT BYTES = %d\n", buf, count_bytes);
  write(fd, buf, strlen(buf));
  printf("vou escrever %s\n", string);
  write(fd, string, count_bytes);
  close(fd);
}

void close_HTML(){
  printf("CORAGEM:%s", currentHTML);
  char file[80];
  sprintf(file, "%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char* buf = "</body>\n</html>\n";
  write(fd, buf, strlen(buf));
  close(fd);
}

void titulo_HTML(char* str){
  char file[80];
  sprintf(file, "%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char string[50];
  int count_bytes = sprintf(string,"<h2>%s</h2>\n", str);
  write(fd, string, count_bytes);
  close(fd);
}

void texto_HTML(char* str){
  char file[80];
  sprintf(file, "%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char string[200];
  int count_bytes = sprintf(string,"<p>%s</p>\n", str);
  write(fd, string, count_bytes);
  close(fd);
}
char* poeEspaco(char* c){
  char* res = strdup(c);
  for(int i = 0; i < strlen(c); i++){
    if(res[i] == '_'){
      res[i] = ' ';
    }
  }
  return res;
}

char* retiraDoisPontos(char* relacao){
    char* rel;
    if(relacao[0] == ':') {
      rel = relacao + 1;
      return rel;
    }
    return relacao;
}

char* formataObjeto(char* objeto){
    char* obj;
    if(objeto[0] == '\"') {
      obj = strdup(objeto + 1);
      obj[strlen(obj)-1] = '\0';
    }
    return obj;
  }

void triplos_HTML(char *str){
  int count_bytes;
  char file[80];
  sprintf(file, "%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char string[200];
  if(str[0] == '\"') {
    count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é %s %s\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1), retiraDoisPontos(currentRelacao), formataObjeto(str));
  }
  else{
    count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é %s <a href=\"./%s.html\">%s</a>\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1), retiraDoisPontos(currentRelacao), str+1, poeEspaco(str+1));
    printf("NUNO AZEVEDO diz: %s", string);
  }
  write(fd, string, count_bytes);
  close(fd);
}

%}

%union{ char* palavra; char* objeto;}

%token IN INITIT INITTRIP PONTOVIRGULA VIRG SPACE
%token <palavra> pal
%token <palavra> esp
%token <objeto> obj
%token <objeto> suj
%token <objeto> img

%%
Anotacao : IN Doc Triplos                {printf("YACC:Reconheci comando Anotacao\n");}
         | IN Doc Triplos Anotacao       {printf("YACC:Reconheci comando varias Anotacoes\n");}
         ;

Doc : Topico Titulo Texto         {printf("YACC:Reconheci doc\n");}
    ;

Topico : pal                      {create_HTML($1); printf("YACC:Reconheci topico\n");}
       ;

Titulo : INITIT pal               {titulo_HTML($2); printf("YACC:Reconheci titulo\n");}
       ;

Texto : Texto pal                {texto_HTML($2); printf("YACC:Reconheci texto\n");}
      | pal                       {texto_HTML($1); printf("YACC:Reconheci texto\n");}
      ;

Triplos : INITTRIP TriplosList          {close_HTML(); printf("YACC:Reconheci triplos\n");}
        ;

TriplosList : Sujeito SPACE Relacoes          {printf("YACC:Reconheci triploList\n");}
            | Sujeito SPACE Relacoes TriplosList      {printf("YACC:Reconheci triploList com triploList\n");}
            ;


Relacoes : Relacao SPACE ListaObjeto              {printf("YACC:Reconheci Relacoes:\n");}
         | Relacao SPACE ListaObjeto SPACE Relacoes     {printf("YACC:Reconheci Relacoes com Relacoes:\n");}
         | RelacaoEspecial SPACE ListaObjeto               {printf("YACC:Reconheci Relacao ESPECIAL:\n");}
         | RelacaoEspecial SPACE ListaObjeto SPACE Relacoes        {printf("YACC:Reconheci Relacoes ESPECIAL COM RELACOES:\n");}
         | RelacaoImagem SPACE ListaObjeto               {printf("YACC:Reconheci Relacao IMAGEM:\n");}
         | RelacaoImagem SPACE ListaObjeto SPACE Relacoes        {printf("YACC:Reconheci Relacoes IMAGEM COM RELACOES:\n");}
         ;

Relacao : obj               {currentRelacao = $1; printf("YACC:Reconheci Relacao\n");}
        ;

RelacaoEspecial : esp       {currentRelacao = $1; printf("YACC:Reconheci RelacaoESPECIAL: %s\n", $1);}
                ;

RelacaoImagem : img           {printf("YACC:Reconheci Relacao IMAGEM\n");}
              ;

ListaObjeto : Objeto PONTOVIRGULA         {printf("YACC:Reconheci Lista objeto\n");}
            | Objeto VIRG SPACE ListaObjeto     {printf("YACC:Reconheci Lista objeto com lista objeto\n");}
            ;

Sujeito : suj             {currentSujeito = $1; printf("YACC:Reconheci sujeito %s\n", $1);}
        ;

Objeto : obj              {triplos_HTML($1); printf("YACC:Reconheci objeto\n");}
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
