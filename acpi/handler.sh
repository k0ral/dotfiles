#!/bin/sh
# Default acpi script that takes an entry for all actions

# NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
#       modify it to not use /sys

minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

set $*

case "$1" in
    button/power)
        #echo "PowerButton pressed!">/dev/tty5
        case "$2" in
            PBTN|PWRF)  logger "PowerButton pressed: $2" ;;
            *)          logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            #SLPB)   echo -n mem >/sys/power/state ;;
            SLPB)   pm-hibernate ;;
            *)      logger "ACPI action undefined: $2" ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        echo "powersave" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                        echo "powersave" >/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
                        echo "powersave" >/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
                        echo "powersave" >/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
                        echo -n $minspeed >$setspeed
                        #/etc/laptop-mode/laptop-mode start
                    ;;
                    00000001)
                        echo "conservative" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                        echo "conservative" >/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
                        echo "conservative" >/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
                        echo "conservative" >/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
                        echo -n $maxspeed >$setspeed
                        #/etc/laptop-mode/laptop-mode stop
                    ;;
                esac
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)   #echo "offline" >/dev/tty5
                    ;;
                    00000001)   #echo "online"  >/dev/tty5
                    ;;
                esac
                ;;
            CPU0)	
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        #echo "LID switched!">/dev/tty5
        ;;
    hotkey)
        case "$3" in
                    00000030)
                       amixer -c 0 set Master 5%+
                    ;;
                    00000031)
                       amixer -c 0 set Master 5%-
                    ;;
                    00000032)
                       if [ -n "$(amixer get Master | grep off)" ]; then 
                        amixer -c 0 set Master unmute; 
                       else
                        amixer -c 0 set Master mute; 
                       fi
                    ;;
                    0000005c)
                       if [ -z "$(lsmod |grep acpi_cpufreq)" ]; then
                        modprobe acpi_cpufreq
                        /etc/rc.d/cpufreq start
                       else
                        /etc/rc.d/cpufreq stop
                        rmmod acpi_cpufreq
                       fi
                    ;;
    esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac
