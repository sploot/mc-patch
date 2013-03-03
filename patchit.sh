#!/bin/bash

IFS="
"
DIR="${HOME}/Library/Application Support/minecraft/bin/"
bak="backup"
bakFile="mc.orig.jar"
tmpdir="work"
patchdir=`PWD`
LISTFILE="${patchdir}/patch_order.list"


cd $DIR

if [ ! -d $bak ]; then
   mkdir $bak
fi
if [ ! -f "./${bak}/$bakFile" ]; then
   cp minecraft.jar ${bak}/${bakFile}
fi

if [ -f "minecraft.jar" ]; then
   oldfile="`date +%m-%d-%y_%H-%M-%S`.mc.jar"
   mv minecraft.jar ${bak}/${oldfile}
fi

if [ -d $tmpdir ]; then
   cd $tmpdir
else
   mkdir $tmpdir
   cd $tmpdir
fi

jar -xf ../${bak}/${bankFile}

for i in $(cat $LISTFILE); do
   if [[ $i =~ "zip" ]]; then
      unzip -o ${patchdir}/$i
      echo "Applied $i"
   else
      echo "Don't know what to do with $i"
      exit 1
   fi
done

rm -rf META-INF/*

jar -cf ../minecraft.jar .
#cd to minecraft/bin
cd ../
rm -rf $tmpdir

#cd to minecraft base dir
cd ../

if [ ! -d mods ]; then
   mkdir mods
fi
cd mods

for mod in $(ls $patchdir/mods); do
   shortmod=`echo $mod | sed -e 's/\(.*\)[- ].*/\1/'`
   if [ ! -f $mod ]; then
      if [[ `ls . | grep -c $shortmod` == 1 ]]; then
         echo
         echo
         echo "[WARNING] Different version:"
         oldmod=`ls . | grep $shortmod`
         echo "Existing: $oldmod"
         echo "New: $mod"
         echo "Install new mod? [y/N]  "
         read ans
         if [[ $ans == "y" ]] || [[ $ans == "Y" ]]; then
            cp $mod .
            rm $oldmod
         fi
      else
         cp $mod .
      fi
   fi
done
cd ../

if [ ! -d coremods ]; then
   mkdir coremods
fi
cd coremods
for mod in $(ls $patchdir/coremods); do
   shortmod=`echo $mod | sed -e 's/\(.*\)[- ].*/\1/'`
   if [ ! -f $mod ]; then
      if [[ `ls . | grep -c $shortmod` == 1 ]]; then
         echo
         echo
         echo "[WARNING] Different version:"
         oldmod=`ls . | grep $shortmod`
         echo "Existing: $oldmod"
         echo "New: $mod"
         echo "Install new mod? [y/N]  "
         read ans
         if [[ $ans == "y" ]] || [[ $ans == "Y" ]]; then
            cp $mod .
            rm $oldmod
         fi
      else
         cp $mod .
      fi
   fi
done
cd ../
