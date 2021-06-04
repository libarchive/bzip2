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

https://gitlab.com/bzip2/bzip2

Maintenance happens in the `master` branch.  There is an effort to port
Bzip2 gradually to [Rust] in a `rustify` branch.

To report bugs, or to view existing reports, please do so in [Bzip2's
repository][gitlab] as well.

[coc]: code-of-conduct.md
[gitlab]: https://gitlab.com/bzip2/bzip2/issues
[Rust]: https://www.rust-lang.org


## Compiling Bzip2 and libbz2

Please see the [`COMPILING.md`][COMPILING.md] file for details.  This includes
instructions for buliding using Meson, CMake, or nmake.

[COMPILING.md]: COMPILING.md

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

Since June 2021, the maintainer of Bzip2/libbz2 is Micah Snyder.

### Special thanks

Thanks to Julian Seward, the original author of Bzip2/libbz2, for
creating the program and making it a very compelling alternative to
previous compression programs back in the early 2000's.  Thanks to
Julian also for letting Federico carry on with the maintainership of
the program.
