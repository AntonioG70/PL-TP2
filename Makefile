anotacoes : y.tab.o
		gcc -o anotacoes y.tab.o

y.tab.o : y.tab.c lex.yy.c
		gcc -c y.tab.c

lex.yy.o : lex.yy.c
		gcc -c lex.yy.c

y.tab.c y.tab.h : anotacoes.y
		yacc -d anotacoes.y

lex.yy.c : anotacoes.l y.tab.h
		flex anotacoes.l

clear:
		rm html/*.html anotacoes lex.yy.c y.tab.c y.tab.o y.tab.h
