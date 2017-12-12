#!/bin/bash
mkdir /cygdrive/c/epic4
mkdir /cygdrive/c/epic4/bin
mkdir /cygdrive/c/epic4/libexec
mkdir -p /cygdrive/c/epic4/terminfo/x
mkdir /cygdrive/c/epic4/docs
mkdir -p /cygdrive/c/epic4/share/epic
mkdir -p /cygdrive/c/epic4/share/epic/script
mkdir -p /cygdrive/c/epic4/sosdg
cp -f source/epic.exe /cygdrive/c/epic4/bin/epic.exe
cp -f source/wserv4.exe /cygdrive/c/epic4/libexec/wserv4.exe
cp -f /bin/cygwin1.dll /cygdrive/c/epic4/bin/cygwin1.dll
cp -f /bin/cygssl-0.9.8.dll /cygdrive/c/epic4/bin/
cp -f /bin/cygcrypto-0.9.8.dll /cygdrive/c/epic4/bin/
cp -f /bin/cygcrypt-0.dll /cygdrive/c/epic4/bin/
cp -f /bin/cygncurses-8.dll /cygdrive/c/epic4/bin/cygncurses-8.dll
cp -f /bin/libW11.dll /cygdrive/c/epic4/bin/libW11.dll
cp -f /bin/rxvt.exe /cygdrive/c/epic4/bin/rxvt.exe
cp -f /usr/share/terminfo/x/xterm /cygdrive/c/epic4/terminfo/x/xterm
cp -f /usr/share/terminfo/c/cygwin /cygdrive/c/epic4/terminfo/c/cygwin
strip /cygdrive/c/epic4/bin/*.exe
strip /cygdrive/c/epic4/libexec/*.exe


mount -t C:/epic4 /mnt/epic4
cp -f epic4-noncygwin-install.sh epic4-noncygwin-configure.sh "C:/installer scripts/epic4.nsi" /mnt/epic4/sosdg/
DOCFILES="Readme Bug_form KNOWNBUGS COPYRIGHT Votes"
cd ../
for i in $DOCFILES; do
        echo "Converting $i..."
        rm -f /mnt/epic4/docs/$i
        awk 1 $i > /mnt/epic4/docs/$i
done
cp -fr doc/* /mnt/epic4/docs
mv /cygdrive/c/epic4/docs/Readme /cygdrive/c/epic4/docs/readme-unix.txt
rm -fr /cygdrive/c/epic4/share/epic/help /cygdrive/c/epic4/share/epic/script
mkdir /cygdrive/c/epic4/share/epic/script
cp -fr help /mnt/epic4/share/epic/
cp -fr script/* /mnt/epic4/share/epic/script/
umount /mnt/epic4
cd /cygdrive/c/epic4
find /cygdrive/c/epic4 -name CVS | xargs rm -frv
find /cygdrive/c/epic4 -name cvs | xargs rm -frv
find $CLAMAV -name ".cvsignore" | xargs rm -frv
find $CLAMAV -name ".\#*" | xargs rm -frv
chown -R Administrators:Users /cygdrive/c/epic4
