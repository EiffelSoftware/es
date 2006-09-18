
all: ci18n.a

main.o: main.c
	gcc -Wall -o $@ -c main.c

ci18n.a: main.o
	rm -f $@
	ar rc $@ main.o
	ranlib $@

