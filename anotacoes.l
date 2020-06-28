%{
#include "y.tab.h"
#include "string.h"
%}
%option noyywrap
%option yylineno
%x TRIPLOS
%%
<*>^===\ :                                 {BEGIN INITIAL; return(IN);}
^(?i:@tit:)                                {return(INITIT);}
^(?i:@triplos:)                            {BEGIN TRIPLOS; return(INITTRIP);}
<TRIPLOS>:img                              {yylval.palavra = strdup(yytext); return img;}
<TRIPLOS>a/[ ]+:                           {yylval.palavra = strdup(yytext); return esp;}
<TRIPLOS>[ ]+                              {return SPACE;}
[a-zA-Z\ óáéí.0-9\-,;]+\n                  {yylval.palavra = strdup(yytext); return pal;}
<TRIPLOS>,                                 {return(VIRG);}
<TRIPLOS>[;.]                              {return(PONTOVIRGULA);}
<TRIPLOS>^:[A-Za-zóáéí0-9_]+               {yylval.objeto = strdup(yytext); return suj;}
<TRIPLOS>:[A-Za-zóáéí0-9_]+                {yylval.objeto = strdup(yytext); return obj;}
<TRIPLOS>\"[A-Za-zóáéí.0-9_]+\"            {yylval.objeto = strdup(yytext); return obj;}
<*>.|\n                                       {;}
%%
