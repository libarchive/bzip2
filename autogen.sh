touch AUTHORS
touch ChangeLog
libtoolize --force
aclocal
automake --add-missing --gnu
autoconf
