all:
	flex src/table_des_symboles.lex
	mv lex.yy.c src/
	gcc -lfl -o tp.exe src/lex.yy.c header/table_des_symboles.h
clean:
	rm src/lex.yy.c tp.exe
