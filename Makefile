
CC = gcc
SH = /bin/sh

CFLAGS = -O3 -fomit-frame-pointer -funroll-loops



all:
	cat words0
	$(CC) $(CFLAGS) -o bzip2 bzip2.c
	$(CC) $(CFLAGS) -o bzip2recover bzip2recover.c
	rm -f bunzip2
	ln -s ./bzip2 ./bunzip2
	cat words1
	./bzip2 -1 < sample1.ref > sample1.rb2
	./bzip2 -2 < sample2.ref > sample2.rb2
	./bunzip2 < sample1.bz2 > sample1.tst
	./bunzip2 < sample2.bz2 > sample2.tst
	cat words2
	cmp sample1.bz2 sample1.rb2 
	cmp sample2.bz2 sample2.rb2
	cmp sample1.tst sample1.ref
	cmp sample2.tst sample2.ref
	cat words3


clean:
	rm -f bzip2 bunzip2 bzip2recover sample*.tst sample*.rb2

