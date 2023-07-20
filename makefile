calc: lex.yy.c calc.tab.c
	gcc -o calc calc.tab.c lex.yy.c -lfl

lex.yy.c: calc.tab.c calc.l
	lex calc.l

calc.tab.c: calc.y
	bison -dv calc.y
	mkdir -p output

clean: 
	rm -rf lex.yy.c calc.tab.c calc.tab.h calc calc.dSYM calc.output calc.exe output

main: calc
	./calc.exe main

NUMBERS = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15


	


