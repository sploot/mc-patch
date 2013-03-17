#!/bin/bash

nick=""

IFS="
"

# Mod list; comment out the mods to not disable with the -d flag
BL=(
CoFHCore
ThermalExpansion
buildcraft
forestry
industrialcraft
)

USAGE() {
   echo "
$0 [-d]

-d    disable blacklisted mods

Blacklist currently includes:
${BL[@]}
"
exit 1
}


while getopts "d" opt; do
   case $opt in
      d) DISABLE=1
         ;;
      ?)
         USAGE
         ;;
   esac
done

cd ~/Library/Application\ Support/minecraft/mods

for i in ${BL[@]}; do
   if [ -f $i* ]; then
      fn=`ls $i*`
      if [[ `echo $fn |grep -c "jar$"` != 1 ]] && [[ `echo $fn |grep -c "zip$"` != 1 ]]; then
         # .jar or .zip
         if [[ ! $DISABLE ]]; then
            mv $fn `echo $fn|sed -e 's/\(.*\)\.disabled/\1/'`
            if [[ $? != 0 ]]; then
               ERR=1
               echo ERROR: $fn
               echo mv $fn `echo $fn|sed -e 's/\(.*\)\.disabled/\1/'`
            fi
         fi
      else
         echo else
         if [[ $DISABLE ]]; then
            mv $fn ${fn}.disabled
            if [[ $? != 0 ]]; then
               ERR=1
               echo ERROR: $i
               echo mv $fn ${fn}.disabled
            fi
         fi
      fi
   fi
done

if [[ $ERR == 1 ]]; then
   exit 1
fi

cd ..
#open /Applications/Minecraft.app
java -Xms512m -Xmx1024m -cp "bin/*" -Djava.library.path="bin/natives" net.minecraft.client.Minecraft $nick
