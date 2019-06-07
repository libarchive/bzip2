ACLOCAL_AMFLAGS = -I m4
lib_LTLIBRARIES = libbz2.la
libbz2_la_SOURCES = \
	blocksort.c \
	huffman.c \
	crctable.c \
	randtable.c \
	compress.c \
	decompress.c \
	bzlib.c

libbz2_la_LDFLAGS = \
	-version-info $(BZIP2_LT_CURRENT):$(BZIP2_LT_REVISION):$(BZIP2_LT_AGE) \
	-no-undefined

include_HEADERS = bzlib.h

noinst_HEADERS = bzlib_private.h

bin_PROGRAMS = bzip2 bzip2recover

bzip2_SOURCES = bzip2.c
bzip2_LDADD = libbz2.la

bzip2recover_SOURCES = bzip2recover.c
bzip2recover_LDADD = libbz2.la

bin_SCRIPTS = bzgrep bzmore bzdiff

man_MANS = man/bzip2.1 man/bzgrep.1 man/bzmore.1 man/bzdiff.1

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = bzip2.pc

$(pkgconfig_DATA): $(srcdir)/bzip2.pc.in config.status

install-exec-hook:
	rm -f $(DESTDIR)$(bindir)/`echo "bunzip2" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzcat" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzegrep" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzfgrep" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzless" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzcmp" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	$(LN_S) `echo "bzip2" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'` $(DESTDIR)$(bindir)/`echo "bunzip2" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	$(LN_S) `echo "bzip2" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'` $(DESTDIR)$(bindir)/`echo "bzcat" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	$(LN_S) `echo "bzgrep" | sed 's,^.*/,,;$(transform)'` $(DESTDIR)$(bindir)/`echo "bzegrep" | sed 's,^.*/,,;$(transform)'`
	$(LN_S) `echo "bzgrep" | sed 's,^.*/,,;$(transform)'` $(DESTDIR)$(bindir)/`echo "bzfgrep" | sed 's,^.*/,,;$(transform)'`
	$(LN_S) `echo "bzmore" | sed 's,^.*/,,;$(transform)'` $(DESTDIR)$(bindir)/`echo "bzless" | sed 's,^.*/,,;$(transform)'`
	$(LN_S) `echo "bzdiff" | sed 's,^.*/,,;$(transform)'` $(DESTDIR)$(bindir)/`echo "bzcmp" | sed 's,^.*/,,;$(transform)'`

install-data-hook:
	echo ".so man1/`echo "bzip2" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bunzip2" | sed 's,^.*/,,;$(transform)'`.1
	echo ".so man1/`echo "bzip2" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bzcat" | sed 's,^.*/,,;$(transform)'`.1
	echo ".so man1/`echo "bzgrep" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bzegrep" | sed 's,^.*/,,;$(transform)'`.1
	echo ".so man1/`echo "bzgrep" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bzfgrep" | sed 's,^.*/,,;$(transform)'`.1
	echo ".so man1/`echo "bzmore" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bzless" | sed 's,^.*/,,;$(transform)'`.1
	echo ".so man1/`echo "bzdiff" | sed 's,^.*/,,;$(transform)'`.1" >$(DESTDIR)$(mandir)/man1/`echo "bzcmp" | sed 's,^.*/,,;$(transform)'`.1

uninstall-hook:
	rm -f $(DESTDIR)$(bindir)/`echo "bunzip2" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzcat" | sed 's,^.*/,,;$(transform);s/$$/$(EXEEXT)/'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzegrep" | sed 's,^.*/,,;$(transform)'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzfgrep" | sed 's,^.*/,,;$(transform)'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzless" | sed 's,^.*/,,;$(transform)'`
	rm -f $(DESTDIR)$(bindir)/`echo "bzcmp" | sed 's,^.*/,,;$(transform)'`
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bunzip2" | sed 's,^.*/,,;$(transform)'`.1
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bzcat" | sed 's,^.*/,,;$(transform)'`.1
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bzegrep" | sed 's,^.*/,,;$(transform)'`.1
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bzfgrep" | sed 's,^.*/,,;$(transform)'`.1
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bzless" | sed 's,^.*/,,;$(transform)'`.1
	rm -f $(DESTDIR)$(mandir)/man1/`echo "bzcmp" | sed 's,^.*/,,;$(transform)'`.1

check-local: bzip2
	@cat $(top_srcdir)/tests/words1
	@mkdir $(top_builddir)/tests/
	./bzip2 -1  <$(top_srcdir)/tests/sample1.ref >$(top_builddir)/tests/sample1.rb2
	./bzip2 -2  <$(top_srcdir)/tests/sample2.ref >$(top_builddir)/tests/sample2.rb2
	./bzip2 -3  <$(top_srcdir)/tests/sample3.ref >$(top_builddir)/tests/sample3.rb2
	./bzip2 -d  <$(top_srcdir)/tests/sample1.bz2 >$(top_builddir)/tests/sample1.tst
	./bzip2 -d  <$(top_srcdir)/tests/sample2.bz2 >$(top_builddir)/tests/sample2.tst
	./bzip2 -ds <$(top_srcdir)/tests/sample3.bz2 >$(top_builddir)/tests/sample3.tst
	cmp $(top_srcdir)/tests/sample1.bz2 $(top_builddir)/tests/sample1.rb2
	cmp $(top_srcdir)/tests/sample2.bz2 $(top_builddir)/tests/sample2.rb2
	cmp $(top_srcdir)/tests/sample3.bz2 $(top_builddir)/tests/sample3.rb2
	cmp $(top_builddir)/tests/sample1.tst $(top_srcdir)/tests/sample1.ref
	cmp $(top_builddir)/tests/sample2.tst $(top_srcdir)/tests/sample2.ref
	cmp $(top_builddir)/tests/sample3.tst $(top_srcdir)/tests/sample3.ref
	@cat $(top_srcdir)/tests/words3

manual: $(top_builddir)/docs/manual.html $(top_builddir)/docs/manual.ps $(top_builddir)/docs/manual.pdf

docs/manual.ps: $(MANUAL_SRCS)
	cd $(top_srcdir)/docs; ./xmlproc.sh -ps manual.xml

docs/manual.pdf: $(MANUAL_SRCS)
	cd $(top_srcdir)/docs; ./xmlproc.sh -pdf manual.xml

docs/manual.html: $(MANUAL_SRCS)
	cd $(top_srcdir)/docs; ./xmlproc.sh -html manual.xml

EXTRA_DIST = \
	$(bin_SCRIPTS) \
	$(man_MANS) \
	README.XML.STUFF \
	README.autotools \
	bzip2.pc.in \
	bzip2.txt \
	dlltest.c \
	dlltest.dsp \
	docs/bz-common.xsl \
	docs/bz-common.xsl \
	docs/bz-fo.xsl \
	docs/bz-fo.xsl \
	docs/bz-html.xsl \
	docs/bz-html.xsl \
	docs/bzip.css \
	docs/bzip.css \
	docs/entities.xml \
	docs/format.pl \
	docs/manual.html \
	docs/manual.pdf \
	docs/manual.ps \
	docs/manual.xml \
	docs/meson.build \
	docs/xmlproc.sh \
	libbz2.def \
	libbz2.dsp \
	makefile.msc \
	man/bzip2.1.preformatted \
	man/meson.build \
	meson.build \
	meson_options.txt \
	mk251.c \
	spewG.c \
	tests/meson.build \
	tests/sample1.bz2 \
	tests/sample1.ref \
	tests/sample2.bz2 \
	tests/sample2.ref \
	tests/sample3.bz2 \
	tests/sample3.ref \
	tests/words0 \
	tests/words1 \
	tests/words2 \
	tests/words3 \
	unzcrash.c
