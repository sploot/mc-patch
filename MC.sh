#!/bin/bash

nick=""

USAGE() {
   echo "
$0 [-b]

-b    Enable buildcraft
"
}

while getopts "b" opt; do
   case $opt in
      b) BUILDCRAFT=1
         ;;
      ?)
         USAGE
         ;;
   esac
done

cd ~/Library/Application\ Support/minecraft/mods
if [ -f build* ]; then
   bc=`ls buildcraft*`
   if [[ `echo $bc |grep -c jar$` != 1 ]]; then
      if [[ $BUILDCRAFT ]]; then
         mv $bc `echo $bc|sed -e 's/\(.*\.jar\).*/\1/'`
      fi
   else
      if [[ ! $BUILDCRAFT ]]; then
         mv $bc ${bc}.disabled
      fi
   fi
fi

cd ..
#open /Applications/Minecraft.app
java -Xms512m -Xmx1024m -cp "bin/*" -Djava.library.path="bin/natives" net.minecraft.client.Minecraft $nick
