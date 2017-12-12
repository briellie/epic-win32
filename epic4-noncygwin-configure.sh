#!/bin/bash
export CFLAGS="-O2 -march=pentium -mtune=pentium4 -DFD_SETSIZE=2048 \
	-fno-strict-aliasing -fomit-frame-pointer -pipe"
export LDFLAGS="-Wl,--enable-auto-image-base \
	-Wl,--enable-runtime-pseudo-reloc -s"

export CC="ccache gcc"
#make distclean
../configure --prefix=/cygdrive/c/epic4 \
	--cache-file=/usr/src/config-cache/epic4-cache \
	--with-ssl --without-perl --without-tcl --with-ipv6 \
	--disable-dependency-tracking
