#!/bin/bash
mkdir /cygdrive/c/epic5
mkdir /cygdrive/c/epic5/bin
mkdir /cygdrive/c/epic5/libexec
mkdir -p /cygdrive/c/epic5/terminfo/x
mkdir /cygdrive/c/epic5/docs
mkdir -p /cygdrive/c/epic5/share/epic5
mkdir -p /cygdrive/c/epic5/share/epic5/script
mkdir -p /cygdrive/c/epic5/sosdg
cp -f source/epic5.exe /cygdrive/c/epic5/bin/epic.exe
cp -f source/wserv4.exe /cygdrive/c/epic5/libexec/wserv4.exe
cp -f /bin/cygwin1.dll /cygdrive/c/epic5/bin/cygwin1.dll
cp -f /bin/cygssl-0.9.8.dll /cygdrive/c/epic5/bin/
cp -f /bin/cygcrypto-0.9.8.dll /cygdrive/c/epic5/bin/
cp -f /bin/cygcrypt-0.dll /cygdrive/c/epic5/bin/
cp -f /bin/cygncurses-8.dll /cygdrive/c/epic5/bin/cygncurses-8.dll
cp -f /bin/libW11.dll /cygdrive/c/epic5/bin/libW11.dll
cp -f /bin/rxvt.exe /cygdrive/c/epic5/bin/rxvt.exe
cp -f /usr/share/terminfo/x/xterm /cygdrive/c/epic5/terminfo/x/xterm
cp -f /usr/share/terminfo/c/cygwin /cygdrive/c/epic5/terminfo/c/cygwin
strip /cygdrive/c/epic5/bin/*.exe
strip /cygdrive/c/epic5/libexec/*.exe


mount -t C:/epic5 /mnt/epic5
cp -f epic5-noncygwin-install.sh epic5-noncygwin-configure.sh "C:/installer scripts/epic5.nsi" /mnt/epic5/sosdg/
DOCFILES="Readme Bug_form KNOWNBUGS COPYRIGHT Votes"
cd ../
for i in $DOCFILES; do
        echo "Converting $i..."
        rm -f /mnt/epic5/docs/$i
        awk 1 $i > /mnt/epic5/docs/$i
done
cp -fr doc/* /mnt/epic5/docs
mv /cygdrive/c/epic5/docs/Readme /cygdrive/c/epic5/docs/readme-unix.txt
rm -fr /cygdrive/c/epic5/share/epic5/help /cygdrive/c/epic5/share5/epic/script
mkdir /cygdrive/c/epic5/share/epic5/script
cp -fr /usr/src/epic4-noncygwin/help /mnt/epic5/share/epic5/
cp -fr script/* /mnt/epic5/share/epic5/script/
umount /mnt/epic5
cd /cygdrive/c/epic5
find /cygdrive/c/epic5 -name CVS | xargs rm -frv
find /cygdrive/c/epic5 -name cvs | xargs rm -frv
find $CLAMAV -name ".cvsignore" | xargs rm -frv
find $CLAMAV -name ".\#*" | xargs rm -frv
chown -R Administrators:Users /cygdrive/c/epic5
