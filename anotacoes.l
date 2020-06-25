%{
#include "y.tab.h"
#include "string.h"
%}
%option noyywrap
%option yylineno
%%
a/[ ]+:                   {printf("FLEX DURO:%s",yytext); yylval.palavra = strdup(yytext); return esp;}
[ ]+                      {printf("ESPAÇO CORAGEM%s", yytext);return SPACE;}
[a-zA-Z\ óáéí]+\n         {printf("FLEX1:%s",yytext);yylval.palavra = strdup(yytext); return pal;}
[a-zA-Z\ óáéí]+/^[:]      {printf("FLEX2:%s", yytext);return txt;}
^===\ :                   {printf("FLEX3:%s", yytext);return(IN);}
^(?i:@tit:)               {printf("FLEX4:%s", yytext);return(INITIT);}
^(?i:@triplos:)           {printf("FLEX5:%s", yytext);return(INITTRIP);}
,                         {printf("FLEX6:%s", yytext);return(VIRG);}
;                         {printf("FLEX7:%s", yytext); return(PONTOVIRGULA);}
^:[A-Za-zóáéí]+           {printf("FLEX8:%s", yytext);yylval.objeto = strdup(yytext); return suj;}
:[A-Za-zóáéí]+            {printf("FLEX9:%s", yytext);yylval.objeto = strdup(yytext); return obj;}
%%
