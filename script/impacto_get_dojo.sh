#!/bin/sh

DOJO_RELEASE='1.7.1'
DOJO_DIRECTORY="dojo-release-$DOJO_RELEASE"
DOJO_FILENAME="$DOJO_DIRECTORY.tar.gz"
DOJO_MD5_FILENAME="$DOJO_FILENAME.md5"

DOJO_URL="http://download.dojotoolkit.org/release-$DOJO_RELEASE/$DOJO_FILENAME"
DOJO_MD5_URL="$DOJO_URL.md5"

MD5SUM=`which md5sum`
WGET=`which wget`
CURL=`which curl`

DIR=`dirname $0`
TMP_DIR="$DIR/../.tmp"
FINAL_DIR="$DIR/../root/static/lib/"

if [ ! -e $TMP_DIR ]; then
    mkdir $TMP_DIR
fi
if [ ! -e $FINAL_DIR ]; then
    mkdir $FINAL_DIR
fi

if [ $WGET ]; then
    echo Found wget: $WGET;
    echo
    $WGET -c -O $TMP_DIR/$DOJO_FILENAME     $DOJO_URL
    $WGET -c -O $TMP_DIR/$DOJO_MD5_FILENAME $DOJO_MD5_URL
elif [ $CURL ]; then
    echo Found curl: $CURL;
    echo
    $CURL -o $TMP_DIR/$DOJO_FILENAME     $DOJO_URL
    $CURL -o $TMP_DIR/$DOJO_MD5_FILENAME $DOJO_MD5_URL
else
    echo "You need to have curl or wget installed in order to download dojo.";
fi

if [ $MD5SUM ]; then
    cd $TMP_DIR
    $MD5SUM --status -c $DOJO_MD5_FILENAME

    if [ $? -eq 0 ]; then
        echo "Downloaded the file successfully."
    else
        echo "File downloaded, but corrupt."
    fi

    cd $OLDPWD
else
    echo "Downloaded file, but could not check it's integrity."
fi

echo "Excluding existing files."

rm -rf $FINAL_DIR/dojo
rm -rf $FINAL_DIR/dojox
rm -rf $FINAL_DIR/dijit

echo "Extracting downloaded tarball."

tar xpf $TMP_DIR/$DOJO_FILENAME -C $FINAL_DIR

mv $FINAL_DIR/$DOJO_DIRECTORY/dojo/ $FINAL_DIR/$DOJO_DIRECTORY/dojox/ \
   $FINAL_DIR/$DOJO_DIRECTORY/dijit/ $FINAL_DIR/

rm -rf $FINAL_DIR/$DOJO_DIRECTORY
rm -rf $TMP_DIR

echo "Done installing."
