
CC=gcc
CFLAGS=-Wall -O2 -fomit-frame-pointer -fno-strength-reduce

OBJS= blocksort.o  \
      huffman.o    \
      crctable.o   \
      randtable.o  \
      compress.o   \
      decompress.o \
      bzlib.o

all: lib bzip2 test

bzip2: lib
	$(CC) $(CFLAGS) -c bzip2.c
	$(CC) $(CFLAGS) -o bzip2 bzip2.o -L. -lbz2
	$(CC) $(CFLAGS) -o bzip2recover bzip2recover.c

lib: $(OBJS)
	rm -f libbz2.a
	ar clq libbz2.a $(OBJS)

test: bzip2
	@cat words1
	./bzip2 -1 < sample1.ref > sample1.rb2
	./bzip2 -2 < sample2.ref > sample2.rb2
	./bzip2 -d < sample1.bz2 > sample1.tst
	./bzip2 -d < sample2.bz2 > sample2.tst
	@cat words2
	cmp sample1.bz2 sample1.rb2 
	cmp sample2.bz2 sample2.rb2
	cmp sample1.tst sample1.ref
	cmp sample2.tst sample2.ref
	@cat words3


clean: 
	rm -f *.o libbz2.a bzip2 bzip2recover sample1.rb2 sample2.rb2 sample1.tst sample2.tst

.c.o: $*.o bzlib.h bzlib_private.h
	$(CC) $(CFLAGS) -c $*.c -o $*.o

tarfile:
	tar cvf interim.tar *.c *.h Makefile manual.texi manual.ps LICENSE bzip2.1 bzip2.1.preformatted bzip2.txt words1 words2 words3 sample1.ref sample2.ref sample1.bz2 sample2.bz2 *.html README CHANGES libbz2.def libbz2.dsp dlltest.dsp 

