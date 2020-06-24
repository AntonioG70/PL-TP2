%{
#include "y.tab.h"
%}
%option noyywrap
%%
[a-zA-Z\ óáéí]+\n       {yylval.palavra = strdup(yytext); return pal;}
[a-zA-Z\ óáéí]+             {return txt;}
^===\ :                    {return(IN);}
^(?i:@tit:)               {return(INITIT);}
^(?i:@triplos:)           {return(INITTRIP);}
,                         {return(VIRG);}
;                         {return(PONTOVIRGULA);}
[]
%%
