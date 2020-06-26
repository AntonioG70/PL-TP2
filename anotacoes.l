%{
#include "y.tab.h"
#include "string.h"
%}
%option noyywrap
%option yylineno
%x TRIPLOS
%%
<*>^===\ :                         { printf("FLEX3:%s", yytext); BEGIN INITIAL; return(IN);}
^(?i:@tit:)                        {printf("FLEX4:%s", yytext); return(INITIT);}
^(?i:@triplos:)                 {printf("FLEX5:%s", yytext); BEGIN TRIPLOS; return(INITTRIP);}
<TRIPLOS>:img                      {printf("FLEX IMAGEM:%s",yytext); yylval.palavra = strdup(yytext); return img;}
<TRIPLOS>a/[ ]+:                   {printf("FLEX DURO:%s",yytext); yylval.palavra = strdup(yytext); return esp;}
<TRIPLOS>[ ]+                      {printf("ESPAÇO CORAGEM%s", yytext);return SPACE;}
[a-zA-Z\ óáéí.0-9\-,;]+\n    {printf("FLEX1:%s",yytext);yylval.palavra = strdup(yytext); return pal;}
<TRIPLOS>,                         {printf("FLEX6:%s", yytext);return(VIRG);}
<TRIPLOS>[;.]                         {printf("FLEX7:%s", yytext); return(PONTOVIRGULA);}
<TRIPLOS>^:[A-Za-zóáéí0-9_]+           {printf("FLEX8:%s", yytext);yylval.objeto = strdup(yytext); return suj;}
<TRIPLOS>:[A-Za-zóáéí0-9_]+            {printf("FLEX9:%s", yytext);yylval.objeto = strdup(yytext); return obj;}
<TRIPLOS>\"[A-Za-zóáéí.0-9_]+\"            {printf("FLEX10:%s", yytext);yylval.objeto = strdup(yytext); return obj;}
%%
