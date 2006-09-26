
all: ci18n.a

ci18n.o: ci18n.c
	gcc -Wall -o $@ -c ci18n.c

ci18n.a: ci18n.o
	rm -f $@
	ar rc $@ ci18n.o
	ranlib $@

