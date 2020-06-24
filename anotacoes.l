%{
#include "y.tab.h"
#include "string.h"

%}
%option noyywrap
%option yylineno
%%
[ ]+              {printf("ESPAÇO CORAGEM%s", yytext);return SPACE;}
[a-zA-Z\ óáéí]+\n         {printf("FLEX:%s",yytext);yylval.palavra = strdup(yytext); return pal;}
[a-zA-Z\ óáéí]+           {printf("FLEX:%s", yytext);return txt;}
^===\ :                   {printf("FLEX:%s", yytext);return(IN);}
^(?i:@tit:)               {printf("FLEX:%s", yytext);return(INITIT);}
^(?i:@triplos:)           {printf("FLEX:%s", yytext);return(INITTRIP);}
,                         {printf("FLEX:%s", yytext);return(VIRG);}
;                         {printf("FLEX:%s", yytext); return(PONTOVIRGULA);}
^:[A-Za-zóáéí]+            {printf("FLEX:%s", yytext);yylval.objeto = strdup(yytext); return suj;}
:[A-Za-zóáéí]+            {printf("FLEX:%s", yytext);yylval.objeto = strdup(yytext); return obj;}

%%
