#!/bin/bash

set -e

# optional memory param, default is 512m
MEMORY=$1

KURA_PATH=/opt/eclipse/kura
KURA_LOG=/var/log/kura.log
NOHUP_OUT=/var/log/nohup.out

GLUSTER_MOUNT=/mnt/kura

if [ -d $GLUSTER_MOUNT ]; then
	echo "Using gluster on $GLUSTER_MOUNT ..."
	for dir in data user packages; do
		if [ ! -d $GLUSTER_MOUNT/$dir  ]; then
		   if [ -d $KURA_PATH/$dir ]; then
			echo "Initial copy of $GLUSTER_MOUNT/$dir to $GLUSTER_MOUNT/$dir ..."
			cp -ar $KURA_PATH/$dir $GLUSTER_MOUNT
		   else
			mkdir $GLUSTER_MOUNT/$dir
		   fi
		fi
		#mv $KURA_PATH/$dir $KURA_PATH/$dir.bak
		rm -Rf $KURA_PATH/$dir
		ln -s $GLUSTER_MOUNT/$dir $KURA_PATH/$dir
	done
	echo "Set up of gluster on $GLUSTER_MOUNT done"
fi

if [ -n $MEMORY ]; then
	echo "Setting memory to $MEMORY"
	sed -Ei "s#( -Xm[sx])512m#\1${MEMORY}#g" $KURA_PATH/bin/start_kura.sh
fi

nohup $KURA_PATH/bin/start_kura.sh $KURA_LOG >> $NOHUP_OUT &
KURA_PID=$!

while [ ! -e $KURA_LOG ]; do
	echo "Waiting for kura to write to $KURA_LOG ..."
	sleep 1
done

echo "Print kura start output ..."
cat $NOHUP_OUT

echo "Tail kura log ..."
tail -f $KURA_LOG &

wait $KURA_PID
