
SHELL=/bin/sh
CC=gcc
CFLAGS=-Wall -Winline -O2 -fomit-frame-pointer -fno-strength-reduce

OBJS= blocksort.o  \
      huffman.o    \
      crctable.o   \
      randtable.o  \
      compress.o   \
      decompress.o \
      bzlib.o

all: libbz2.a bzip2 bzip2recover test

bzip2: libbz2.a bzip2.o
	$(CC) $(CFLAGS) -o bzip2 bzip2.o -L. -lbz2

bzip2recover: bzip2recover.o
	$(CC) $(CFLAGS) -o bzip2recover bzip2recover.o

libbz2.a: $(OBJS)
	rm -f libbz2.a
	ar cq libbz2.a $(OBJS)
	@if ( test -f /usr/bin/ranlib -o -f /bin/ranlib -o \
		-f /usr/ccs/bin/ranlib ) ; then \
		echo ranlib libbz2.a ; \
		ranlib libbz2.a ; \
	fi

test: bzip2
	@cat words1
	./bzip2 -1  < sample1.ref > sample1.rb2
	./bzip2 -2  < sample2.ref > sample2.rb2
	./bzip2 -3  < sample3.ref > sample3.rb2
	./bzip2 -d  < sample1.bz2 > sample1.tst
	./bzip2 -d  < sample2.bz2 > sample2.tst
	./bzip2 -ds < sample3.bz2 > sample3.tst
	cmp sample1.bz2 sample1.rb2 
	cmp sample2.bz2 sample2.rb2
	cmp sample3.bz2 sample3.rb2
	cmp sample1.tst sample1.ref
	cmp sample2.tst sample2.ref
	cmp sample3.tst sample3.ref
	@cat words3

PREFIX=/usr

install: bzip2 bzip2recover
	if ( test ! -d $(PREFIX)/bin ) ; then mkdir $(PREFIX)/bin ; fi
	if ( test ! -d $(PREFIX)/lib ) ; then mkdir $(PREFIX)/lib ; fi
	if ( test ! -d $(PREFIX)/man ) ; then mkdir $(PREFIX)/man ; fi
	if ( test ! -d $(PREFIX)/man/man1 ) ; then mkdir $(PREFIX)/man/man1 ; fi
	if ( test ! -d $(PREFIX)/include ) ; then mkdir $(PREFIX)/include ; fi
	cp -f bzip2 $(PREFIX)/bin/bzip2
	cp -f bzip2 $(PREFIX)/bin/bunzip2
	cp -f bzip2 $(PREFIX)/bin/bzcat
	cp -f bzip2recover $(PREFIX)/bin/bzip2recover
	chmod a+x $(PREFIX)/bin/bzip2
	chmod a+x $(PREFIX)/bin/bunzip2
	chmod a+x $(PREFIX)/bin/bzcat
	chmod a+x $(PREFIX)/bin/bzip2recover
	cp -f bzip2.1 $(PREFIX)/man/man1
	chmod a+r $(PREFIX)/man/man1/bzip2.1
	cp -f bzlib.h $(PREFIX)/include
	chmod a+r $(PREFIX)/include/bzlib.h
	cp -f libbz2.a $(PREFIX)/lib
	chmod a+r $(PREFIX)/lib/libbz2.a

clean: 
	rm -f *.o libbz2.a bzip2 bzip2recover \
	sample1.rb2 sample2.rb2 sample3.rb2 \
	sample1.tst sample2.tst sample3.tst

blocksort.o: blocksort.c
	$(CC) $(CFLAGS) -c blocksort.c
huffman.o: huffman.c
	$(CC) $(CFLAGS) -c huffman.c
crctable.o: crctable.c
	$(CC) $(CFLAGS) -c crctable.c
randtable.o: randtable.c
	$(CC) $(CFLAGS) -c randtable.c
compress.o: compress.c
	$(CC) $(CFLAGS) -c compress.c
decompress.o: decompress.c
	$(CC) $(CFLAGS) -c decompress.c
bzlib.o: bzlib.c
	$(CC) $(CFLAGS) -c bzlib.c
bzip2.o: bzip2.c
	$(CC) $(CFLAGS) -c bzip2.c
bzip2recover.o: bzip2recover.c
	$(CC) $(CFLAGS) -c bzip2recover.c

tarfile:
	tar cvf interim.tar blocksort.c huffman.c crctable.c \
	randtable.c compress.c decompress.c bzlib.c bzip2.c \
	bzip2recover.c bzlib.h bzlib_private.h Makefile manual.texi \
	manual.ps LICENSE bzip2.1 bzip2.1.preformatted bzip2.txt \
	words1 words2 words3 sample1.ref sample2.ref sample3.ref \
	sample1.bz2 sample2.bz2 sample3.bz2 dlltest.c \
        *.html README CHANGES libbz2.def libbz2.dsp \
	dlltest.dsp makefile.msc Y2K_INFO

