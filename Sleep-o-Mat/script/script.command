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

    system_sleep_path=$( _helpDefaultRead "system_sleep_path" )
    act_system_sleep=$( _helpDefaultRead "act_system_sleep" )
    
    system_wakeup_path=$( _helpDefaultRead "system_wakeup_path" )
    act_system_wakeup=$( _helpDefaultRead "act_system_wakeup" )
    
    display_dim_path=$( _helpDefaultRead "display_dim_path" )
    act_display_dim=$( _helpDefaultRead "act_display_dim" )

    display_undim_path=$( _helpDefaultRead "display_undim_path" )
    act_display_undim=$( _helpDefaultRead "act_display_undim" )
    
    display_sleep_path=$( _helpDefaultRead "display_sleep_path" )
    act_display_sleep=$( _helpDefaultRead "act_display_sleep" )

    display_wakeup_path=$( _helpDefaultRead "display_wakeup_path" )
    act_display_wakeup=$( _helpDefaultRead "act_display_wakeup" )

    user_idle_path=$( _helpDefaultRead "user_idle_path" )
    act_user_idle=$( _helpDefaultRead "act_user_idle" )
    
    user_resume_path=$( _helpDefaultRead "user_resume_path" )
    act_user_resume=$( _helpDefaultRead "act_user_resume" )
    
    power_plug_path=$( _helpDefaultRead "power_plug_path" )
    act_power_plug=$( _helpDefaultRead "act_power_plug" )
    
    power_unplug_path=$( _helpDefaultRead "power_unplug_path" )
    act_power_unplug=$( _helpDefaultRead "act_power_unplug" )

    if [[ "$act_system_sleep" = "1" && "$system_sleep_path" != "" ]]; then
        c1=$( echo "-s" "$system_sleep_path" )
    fi
    if [[ "$act_system_wakeup" = "1" && "$system_wakeup_path" != "" ]]; then
        c2=$( echo "-w" "$system_wakeup_path" )
    fi
    if [[ "$act_display_dim" = "1" && "$display_dim_path" != "" ]]; then
        c3=$( echo "-D" "$display_dim_path" )
    fi
    if [[ "$act_display_undim" = "1" && "$display_undim_path" != "" ]]; then
        c4=$( echo "-E-" "$display_undim_path" )
    fi
    if [[ "$act_display_sleep" = "1" && "$display_sleep_path" != "" ]]; then
        c5=$( echo "-S" "$display_sleep_path" )
    fi
    if [[ "$act_display_wakeup" = "1" && "$display_wakeup_path" != "" ]]; then
        c5=$( echo "-W" "$display_wakeup_path" )
    fi
    if [[ "$act_user_idle" = "1" && "$user_idle_path" != "" ]]; then
        c6=$( echo "-i" "$user_idle_path" )
    fi
    if [[ "$act_user_resume" = "1" && "$user_resume_path" != "" ]]; then
        c7=$( echo "-r" "$user_resume_path" )
    fi
    if [[ "$act_power_plug" = "1" && "$power_plug_path" != "" ]]; then
        c8=$( echo "-P" "$power_plug_path" )
    fi
    if [[ "$act_power_unplug" = "1" && "$power_unplug_path" != "" ]]; then
        c9=$( echo "-U" "$power_unplug_path" )
    fi
    
    options=$( echo "$c1" "$c2" "$c3" "$c4" "$c5" "$c6" "$c7" "$c8" "$c9" | sed -e 's/\ \ /\ /g' -e 's/-E-/-E/g' |xargs )

    

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
    
    run_check=$( launchctl list |grep sleepwatcher )
    if [[ "$run_check" = "" ]]; then
        _helpDefaultWriteBool NO "daemon_running"
    else
        _helpDefaultWriteBool YES "daemon_running"
    fi
}

function kill_sw()
{
    pkill -f sleepwatcher
}

function start_sw()
{
    chmod +x "$system_sleep_path" "$system_wakeup_path" "$display_dim_path" "$display_undim_path" "$display_sleep_path" "$user_idle_path" "$user_resume_path" "$power_plug_path" "$power_unplug_path"

    ../bin/./sleepwatcher "$options" &
}

function template_system_sleep()
{
    mkdir "$ScriptHome"/.sleepomat
    cp ../config/sleep.sh "$ScriptHome"/.sleepomat/.
    plist_string=$( echo "$ScriptHome"/.sleepomat/sleep.sh )
    _helpDefaultWrite "system_sleep_path" "$plist_string"
    
}

function install_daemon()
{
    if [ ! -f /usr/local/bin/sleepwatcher ]; then
        cp ../bin/sleepwatcher /usr/local/bin/.
        chmod +x /usr/local/bin/sleepwatcher
    fi
    
    cp ../config/de.bernhard-baehr.sleepwatcher.plist "$ScriptHome"/Library/LaunchAgents/.
    
    #../bin/PlistBuddy -c "Delete ProgramArguments" "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
    ../bin/PlistBuddy -c "Add ProgramArguments: string $options" "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
    
    launchctl load -w "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
}

function reload_daemon()
{
    launchctl unload -w "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
    kill_sw
    cp -f ../config/de.bernhard-baehr.sleepwatcher.plist "$ScriptHome"/Library/LaunchAgents/.
    ../bin/PlistBuddy -c "Add ProgramArguments: string $options" "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
    launchctl load -w "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
}

function uninstall_daemon()
{
    launchctl unload -w "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
    rm "$ScriptHome"/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
}

$1
exit 0


