#!/usr/bin/env sh

# /*
#  * Copyright (C) Trafikito.com
#  * All rights reserved.
#  *
#  * Redistribution and use in source and binary forms, with or without
#  * modification, are permitted provided that the following conditions
#  * are met:
#  * 1. Redistributions of source code must retain the above copyright
#  *    notice, this list of conditions and the following disclaimer.
#  * 2. Redistributions in binary form must reproduce the above copyright
#  *    notice, this list of conditions and the following disclaimer in the
#  *    documentation and/or other materials provided with the distribution.
#  *
#  * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
#  * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
#  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#  * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  * SUCH DAMAGE.
#  */

# SYNOPSIS: The trafikito agent wrapper - sources lib/trafikito-agent.sh to allow for dynamic updates

# basedir is $1 to enable this to run from anywhere
if [ $# -ne 2 ]; then
    echo "Usage: $0 <server_id> <trafikito-home>" 1>&2
    exit 1
fi
export BASEDIR=$2

export PATH=/usr/sbin:/usr/bin:/sbin:/bin

START_ON=`date +%S | sed s/^0//`
while true; do
    sec=`date +%S`
    while [ $sec -ne $START_ON ]; do
        sleep 1
        sec=`date +%S`
    done

    sh $BASEDIR/lib/trafikito-agent.sh $BASEDIR
    CYCLE_DELAY=`cat $BASEDIR/var/cycle_delay`
    sleep 1 # in case run takes less than 1 sec
   
    if [ $CYCLE_DELAY -gt 0 ]; then
        echo -n "START_ON $START_ON -> "
        START_ON=$((START_ON + CYCLE_DELAY))
        START_ON=$((START_ON % 60))
        echo $START_ON
    fi
done
