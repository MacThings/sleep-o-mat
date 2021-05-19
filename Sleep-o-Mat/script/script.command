#!/bin/bash
#

function _helpDefaultRead()
{
    VAL=$1

    if [ ! -z "$VAL" ]; then
    defaults read "${ScriptHome}/Library/Preferences/sleep-o-mat.slsoft.de.plist" "$VAL"
    fi
}

ScriptHome=$(echo $HOME)
ScriptTmpPath="$HOME"/.som_temp
MY_PATH="`dirname \"$0\"`"
cd "$MY_PATH"
if [ ! -d "$ScriptTmpPath" ]; then
    mkdir "$ScriptTmpPath"
fi

################################################################
####################### Helper Function ########################
################################################################

function _helpDefaultWrite()
{
    VAL=$1
    local VAL1=$2

    if [ ! -z "$VAL" ] || [ ! -z "$VAL1" ]; then
    defaults write "${ScriptHome}/Library/Preferences/sleep-o-mat.slsoft.de.plist" "$VAL" "$VAL1"
    fi
}

function _helpDefaultWriteBool()
{
    VAL=$1
    local VAL1=$2

    if [ ! -z "$VAL" ] || [ ! -z "$VAL1" ]; then
    defaults write "${ScriptHome}/Library/Preferences/sleep-o-mat.slsoft.de.plist" "$VAL1" -bool $VAL
    fi
}

function _helpDefaultDelete()
{
    VAL=$1

    if [ ! -z "$VAL" ]; then
    defaults delete "${ScriptHome}/Library/Preferences/sleep-o-mat.slsoft.de.plist" "$VAL"
    fi
}

function run_check()
{
    run_check=$( ps ax |grep sleepwatcher | grep -v grep )
    if [[ "$?" = "0" ]]; then
        _helpDefaultWriteBool YES "sleepwatcher_running"
    else
        _helpDefaultWriteBool NO "sleepwatcher_running"
    fi
}

function kill_sw()
{
    pkill -f sleepwatcher
}

function start_sw()
{
    ../bin/./sleepwatcher -S "echo doll" &
}

$1
exit 0


