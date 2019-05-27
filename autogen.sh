mv LICENSE COPYING
mv CHANGES NEWS
touch AUTHORS
touch ChangeLog
libtoolize --force
aclocal
automake --add-missing --gnu
autoconf
