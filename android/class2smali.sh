#!/bin/bash
#Author Jermic
#Date 2016-01-22
DXPATH=$1
INPATH=$2
SHAKA=$3
OUTPATH=$4
DEXPATH=''

if [ -d "$OUTPATH" ]
then
    rm -rf $OUTPATH
fi
mkdir "$OUTPATH"

if [ -d "$INPATH" ]
then
    DEXPATH=`basename $INPATH`
    if [ ${OUTPATH:0-1} = "/"]
    then
        DEXPATH=$OUTPATH$DEXPATH-classes.dex
    else
        DEXPATH=$OUTPATH/$DEXPATH-classes.dex
    fi
echo $DEXPATH
elif [ -f "$INPATH" ]
then
    dexFile=`basename ${OUTPATH}`
fi

java -jar $DXPATH --dex --verbose --no-strict --output=$DEXPATH $INPATH
java -jar $SHAKA bs $DEXPATH -o $OUTPATH