Bzip2
=====

This Bzip2/libbz2, a program and library for lossless, block-sorting
data compression.

Copyright (C) 1996-2010 Julian Seward <jseward@acm.org>

Copyright (C) 2019 Federico Mena Quintero <federico@gnome.org>

Please read the [WARNING], [DISCLAIMER] and [PATENTS] sections in this
file for important information.

This program is released under the terms of the license contained
in the file [COPYING].

[WARNING]: #warning
[DISCLAIMER]: #disclaimer
[PATENTS]: #patents
[COPYING]: COPYING

------------------------------------------------------------------

This version is fully compatible with the previous public releases.

Complete documentation is available in Postscript form (manual.ps),
PDF (manual.pdf) or HTML (manual.html).  A plain-text version of the
manual page is available as bzip2.txt.

## Contributing to Bzip2's development

There is a code of conduct for contributors to Bzip2/libbz2; please
see the file [`code-of-conduct.md`][coc].

Bzip2's source repository is at gitlab.com.  You can view the web
interface here:

https://gitlab.com/federicomenaquintero/bzip2

Maintenance happens in the `master` branch.  There is an effort to port
Bzip2 gradually to Rust in a `rustify` branch.

To report bugs, or to view existing reports, please do so in [Bzip2's
repository][gitlab] as well.

[coc]: code-of-conduct.md
[gitlab]: https://gitlab.com/federicomenaquintero/bzip2/issues


## Compiling Bzip2 and libbz2

Bzip2 can be compiled with the [Meson] build system or with GNU
[Autotools].  You need at least a C compiler.

[Meson]: https://mesonbuild.com
[Autotools]: https://autotools.io/index.html

### Build instructions for Unix (Meson)

The [Meson] build system is the preferred way of building Bzip2.  You
can use these commands to build Bzip2 in a certain `builddir`
directory.

```
meson --prefix /usr builddir
ninja -C builddir
meson test -C builddir --print-errorlogs
ninja -C builddir install
```

### Build instructions for Unix (Autotools)

If you are compiling a tarball:

```sh
./configure --prefix=/usr
make
make check
make install
```

See the [`INSTALL`](#INSTALL) file for details on options you can pass
to the `configure` script to select where to install the compiled
library.

If you are compiling from a git checkout:

```sh
./autogen.sh --prefix=/usr
make
make check
make install
```

### Build instructions for Windows

At least using MS Visual C++ 6, you can build from the unmodified
sources with [makefile.msc](makefile.msc) by issuing, in a command
shell:

```
nmake -f makefile.msc
```

(you may need to first run the MSVC-provided script `VCVARS32.BAT`
so as to set up paths to the MSVC tools correctly).

## WARNING

This program and library (attempts to) compress data by
performing several non-trivial transformations on it.
Unless you are 100% familiar with *all* the algorithms contained
herein, and with the consequences of modifying them, you should NOT
meddle with the compression or decompression machinery.  Incorrect
changes can and very likely *will* lead to disastrous loss of data.

**Please contact the maintainers if you want to modify the algorithms.**

## DISCLAIMER

**I TAKE NO RESPONSIBILITY FOR ANY LOSS OF DATA ARISING FROM THE
USE OF THIS PROGRAM/LIBRARY, HOWSOEVER CAUSED.**

Every compression of a file implies an assumption that the
compressed file can be decompressed to reproduce the original.
Great efforts in design, coding and testing have been made to
ensure that this program works correctly.  However, the complexity
of the algorithms, and, in particular, the presence of various
special cases in the code which occur with very low but non-zero
probability make it impossible to rule out the possibility of bugs
remaining in the program.  DO NOT COMPRESS ANY DATA WITH THIS
PROGRAM UNLESS YOU ARE PREPARED TO ACCEPT THE POSSIBILITY, HOWEVER
SMALL, THAT THE DATA WILL NOT BE RECOVERABLE.

That is not to say this program is inherently unreliable.
Indeed, I very much hope the opposite is true.  Bzip2/libbz2 
has been carefully constructed and extensively tested.

## PATENTS

To the best of my knowledge, Bzip2/libbz2 does not use any patented
algorithms.  However, I do not have the resources to carry out a
patent search.  Therefore I cannot give any guarantee of the above
statement.

## Maintainers

Since June 2019, the maintainer of Bzip2/libbz2 is [Federico Mena
Quintero][federico].  Feel free to contact me for any questions you
may have about Bzip2, both its usage and its development.  You can
contact me in the following ways:

* [Mail me][mail] at federico@gnome.org.

* IRC: I am `federico` on `irc.gnome.org` in the `#rust` or
  `#gnome-hackers` channels.  I'm there most weekdays (Mon-Fri)
  starting at about UTC 14:00 (that's 08:00 my time; I am in the UTC-6
  timezone).  If this is not a convenient time for you, feel free to
  [mail me][mail] and we can arrange a time.

[mail]: mailto:federico@gnome.org
[federico]: https://people.gnome.org/~federico/

### Special thanks

Federico would like to thank Julian Seward, the original author of
Bzip2/libbz2, for creating the program and making it a very compelling
alternative to previous compression programs back in the early
2000's.  Thanks to Julian also for letting Federico carry on with the
maintainership of the program.
