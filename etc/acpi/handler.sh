#!/bin/bash
# Default acpi script that takes an entry for all actions

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF) logger "PowerButton pressed: $2" ;; #poweroff ;;
            *) logger "ACPI action undefined: $2" ;;
        esac ;;
    button/sleep)
        case "$2" in
            #SLPB|SBTN) echo -n mem >/sys/power/state ;;
            *)         logger "ACPI action undefined: $2" ;;
        esac ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger "AC unplugged"
                        #/etc/laptop-mode/laptop-mode start
                    ;;
                    00000001)
                        logger "AC plugged"
                        #/etc/laptop-mode/laptop-mode stop
                    ;;
                esac ;;
            *) logger "ACPI action undefined: $2" ;;
        esac ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000) logger 'Battery online' ;;
                    00000001) logger 'Battery offline' ;;
                esac ;;
            CPU0) ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac ;;
    button/lid)
        case "$3" in
            close) logger 'LID closed' ;;
            open)  logger 'LID opened' ;;
        esac ;;
    button/volumedown) amixer set Master 3%-; logger 'Volume increased' ;;
    button/volumeup)   amixer set Master 3%+; logger 'Volume decreased' ;;
    button/mute)
        if [ -n "$(amixer get Master | grep off)" ]; then
            logger 'Sound unmuted'
            amixer -c 0 set Master unmute;
        else
            logger 'Sound muted'
            amixer -c 0 set Master mute;
        fi ;;
    cd/play) mpc toggle ;;
    cd/next) mpc next ;;
    cd/prev) mpc prev ;;
esac
