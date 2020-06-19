%{
#include "y.tab.h"
%}
%option noyywrap
%%
[a-zA-z]+                 {return(pal);}
^=== :                    {return(IN);}
^(?i:@tit:)               {return(INITIT);}
^(?i:@triplos:)           {return(INITTRIP);}
%%
