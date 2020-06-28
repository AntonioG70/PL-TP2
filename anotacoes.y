%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
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
  sprintf(file, "./html/%s.html", str);
  int fd = open(file, O_CREAT | O_TRUNC | O_WRONLY | O_APPEND, 0666);
  char *buf = "<!DOCTYPE html>\n<html>\n<body>\n";
  char string[30];
  count_bytes = sprintf(string,"<h1>%s</h1>\n", str);
  write(fd, buf, strlen(buf));
  write(fd, string, count_bytes);
  close(fd);
}

void close_HTML(){
  char file[80];
  sprintf(file, "./html/%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char* buf = "</body>\n</html>\n";
  write(fd, buf, strlen(buf));
  close(fd);
}

void titulo_HTML(char* str){
  char file[80];
  sprintf(file, "./html/%s.html", currentHTML);
  int fd = open(file, O_WRONLY | O_APPEND, 0666);
  char string[50];
  int count_bytes = sprintf(string,"<h2>%s</h2>\n", str);
  write(fd, string, count_bytes);
  close(fd);
}

void texto_HTML(char* str){
  char file[80];
  sprintf(file, "./html/%s.html", currentHTML);
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
      return poeEspaco(rel);
    }
    return poeEspaco(relacao);
}

char* formataObjeto(char* objeto){
    char* obj;
    if(objeto[0] == '\"') {
      obj = strdup(objeto + 1);
      obj[strlen(obj)-1] = '\0';
    }
    return poeEspaco(obj);
  }

  void triplos_HTML(char *str){
    int count_bytes;
    char file[80];
    sprintf(file, "./html/%s.html", currentHTML);
    int fd = open(file, O_WRONLY | O_APPEND, 0666);
    char string[200];
    if(strcmp(currentRelacao, ":img") == 0){
      count_bytes = sprintf(string,"<img src=\"../imagens/%s\" alt=\"Coragem\" title=\"%s\">\n", formataObjeto(str), currentSujeito);
    }
    else if(strcmp(currentRelacao, "a") == 0){
      if(str[0] == '\"' && strcmp(currentRelacao, ":img") != 0) {
        count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é %s\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1),formataObjeto(str));
      }
      else{
        count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é <a href=\"./%s.html\">%s</a>\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1), str+1, poeEspaco(str+1));
      }
    } else {
      if(str[0] == '\"' && strcmp(currentRelacao, ":img") != 0) {
        count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é %s %s\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1), retiraDoisPontos(currentRelacao), formataObjeto(str));
      }
      else{
        count_bytes = sprintf(string,"<p><a href=\"./%s.html\">%s</a> é %s <a href=\"./%s.html\">%s</a>\n</p>", currentSujeito+1, poeEspaco(currentSujeito+1), retiraDoisPontos(currentRelacao), str+1, poeEspaco(str+1));
      }
    }

    write(fd, string, count_bytes);
    close(fd);
  }

void create_Blank_HTML(char* str){
  char file[80];
  if(str[0] == ':'){
    sprintf(file, "./html/%s.html", str+1);
    int fd = open(file, O_WRONLY | O_APPEND | O_CREAT, 0666);
    close(fd);
  }
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
Anotacao : IN Doc Triplos
         | IN Doc Triplos Anotacao
         ;

Doc : Topico Titulo Texto
    ;

Topico : pal                      {create_HTML($1);}
       ;

Titulo : INITIT pal               {titulo_HTML($2);}
       ;

Texto : Texto pal                {texto_HTML($2);}
      | pal                       {texto_HTML($1);}
      ;

Triplos : INITTRIP TriplosList          {close_HTML();}
        ;

TriplosList : Sujeito SPACE Relacoes
            | Sujeito SPACE Relacoes TriplosList
            ;


Relacoes : Relacao SPACE ListaObjeto
         | Relacao SPACE ListaObjeto SPACE Relacoes
         | RelacaoEspecial SPACE ListaObjeto
         | RelacaoEspecial SPACE ListaObjeto SPACE Relacoes
         | RelacaoImagem SPACE ListaObjeto
         | RelacaoImagem SPACE ListaObjeto SPACE Relacoes
         ;

Relacao : obj               {currentRelacao = $1;}
        ;

RelacaoEspecial : esp       {currentRelacao = $1;}
                ;

RelacaoImagem : img           {currentRelacao = $1;}
              ;

ListaObjeto : Objeto PONTOVIRGULA
            | Objeto VIRG SPACE ListaObjeto
            ;

Sujeito : suj             {currentSujeito = $1;}
        ;

Objeto : obj              {triplos_HTML($1); create_Blank_HTML($1);}
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
