from i3pystatus import Status
from i3pystatus.mail import maildir


status = Status()

status.register("clock", format="%a %-d %b %Y %X",)
status.register("mail",
                backends=[maildir.MaildirMail(directory="/home/koral/mail/gmail-moreau/Inbox") ],
                format="GMAIL {unread}",
                color_unread="#00ff00",
                color="#aaaaaa",
                log_level=20,
                hide_if_null=False, )
status.register("mail",
                backends=[maildir.MaildirMail(directory="/home/koral/mail/mailoo/Inbox") ],
                format="MAILOO {unread}",
                color_unread="#00ff00",
                color="#aaaaaa",
                log_level=20,
                hide_if_null=False, )


status.register("cpu_usage", format="CPU {usage:03}%")
status.register("temp", format="{temp:.0f}°C",)
status.register("mem", format="MEM {used_mem}M")

# The battery monitor has many formatting options, see README for details
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below some threshold while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register("battery",
    format="BAT [{consumption:.2f}W ]{status}{percentage:.2f}%[ {remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=10,
    status={
        "DIS": "↓",
        "CHR": "↑",
        "FULL": "=",
    },)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network", interface="enp58s0f1", format_up="{v4} {bytes_recv:6.1f}K {bytes_sent:5.1f}K",)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp59s0",
    format_up="{essid} {quality:03.0f}% {v4} {bytes_recv:6.1f}K {bytes_sent:5.1f}K",)

# Shows disk usage of /
status.register("disk", path="/", format="/ {avail}G",)

# Note: requires libpulseaudio from PyPI
status.register("pulseaudio", format="♪ {volume}",)
status.register("backlight", format="LIGHT {percentage}")

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
#    format="{title}{status}{album}",
#    status={
#        "pause": "▷",
#        "play": "▶",
#        "stop": "◾",
#    },)

status.run()
