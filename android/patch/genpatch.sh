#/usr/bin/sh

for dir in `find -type d` ; do
if [ -e ../../../../$dir/.git ] ; then
    git --git-dir=../../../../$dir/.git format-patch -o $dir android-9.0.0_r48
fi
done
