#!/bin/sh
# Default acpi script that takes an entry for all actions

minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

set $*

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger "PowerButton pressed: $2"
                #poweroff
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                echo -n mem >/sys/power/state
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
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
            *)
		logger "ACPI action undefined: $2" 
		;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                ;;
            open)
                logger 'LID opened'
                ;;
        esac
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

                    00000040)
                        mpc prev
                    ;;
                    00000041)
                        mpc next
                    ;;
                    00000043)
                        mpc stop
                    ;;
                    00000045)
                        mpc toggle
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
