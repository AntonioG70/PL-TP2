%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
%}

%%


%%

#include "lex.yy.c"

int yyerror(char *s) {
  printf("ERRO: %s\n", s);
  return 0;
}

int int main() {
  yyparse();
  return 0;
}
