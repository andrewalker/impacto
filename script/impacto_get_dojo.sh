#!/bin/sh

WGET=`which wget`
CURL=`which curl`
DOJO_URL='http://download.dojotoolkit.org/release-1.6.1/dojo-release-1.6.1.tar.gz'
DIR=`dirname $0`
TMP_DIR=$DIR/../.tmp
FINAL_DIR=$DIR/../root/static/lib/

mkdir $TMP_DIR
mkdir $FINAL_DIR

if [ $WGET ]; then
    echo Found wget: $WGET;
    echo "Downloading file..."
    $WGET -q -c -O $TMP_DIR/dojo-release.tar.gz $DOJO_URL
    echo "Downloaded. Extracting..."
    tar xpf $TMP_DIR/dojo-release.tar.gz -C $FINAL_DIR
    mv $FINAL_DIR/dojo-release-*/dojo/ $FINAL_DIR/dojo-release-*/dojox/ \
       $FINAL_DIR/dojo-release-*/dijit/ $FINAL_DIR/
    rmdir $FINAL_DIR/dojo-release-*
elif [ $CURL ]; then
    echo Found curl: $CURL;
    # TODO
else
    echo "You need to have curl or wget installed in order to download dojo.";
fi

echo "Done installing."
