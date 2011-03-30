require("awful")            -- Standard awesome library
require("awful.autofocus")
require("awful.rules")
require("beautiful")        -- Theme handling library
require("eminent")          -- Dynamic tagging
--require("naughty")        -- Notification library
require("scratch")          -- Drop-down app
require("vicious")          -- Modular widget library
--require("wicked")         -- Widget library

-- {{{ Naughty configuration
--naughty.config.timeout          = 5
--naughty.config.screen           = 1
--naughty.config.position         = "top_right"
--naughty.config.margin           = 4
--naughty.config.height           = 16
--naughty.config.width            = 300
--naughty.config.gap              = 1
--naughty.config.ontop            = true
--naughty.config.font             = beautiful.font or "Verdana 8"
--naughty.config.icon             = nil
--naughty.config.icon_size        = 16
--naughty.config.fg               = beautiful.fg_focus or '#ffffff'
--naughty.config.bg               = beautiful.bg_focus or '#535d6c'
--naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
--naughty.config.border_width     = 1
--naughty.config.hover_timeout    = nil
-- }}}

-- {{{ Variable definitions
theme_path  = os.getenv("HOME").."/.config/awesome/themes/default/theme.lua"
beautiful.init(theme_path)
terminal    = "urxvtc"
editor      = os.getenv("EDITOR") or "vim"
editor_cmd  = terminal .. " -e " .. editor
modkey      = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- Each screen has its own tag table.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, layouts[5])
    awful.tag.setproperty(tags[s][2], "layout", awful.layout.suit.max)
end
-- }}}

-- {{{ Menu
my_menu = awful.menu.new({ items = {
   --{ "manual", terminal .. " -e man awesome" },
   --{ "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "Open terminal", terminal },
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}})

--mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                        { "open terminal", terminal }
--                                      }
--                            })
-- }}}

-- Constants
spacer          = widget({ type = "textbox" })
separator       = widget({ type = "textbox" })
spacer.text     = "   "
separator.text  = ' <span color="red"><b>|</b></span> '

-- {{{ Clock
--  TODO add a calendar when clicking
wi_clock = widget({ type = "textbox" })
wi_clock.text = '<span color="#ffff00">⌚ '..os.date("%a %d %b | %H:%M")..'</span>'
--wi_clock:buttons({
--    awful.button({ }, 1, os.execute('zenity --calendar'))
--})
-- }}}


--launcher = awful.widget.launcher({image = image(beautiful.awesome_icon), menu = my_menu })
wi_systray = widget({ type = "systray" })


-- {{{ CPU widgets
wi_cpu = widget({type = 'textbox', name = 'wi_cpu'})
vicious.register(wi_cpu, vicious.widgets.cpu, 
    function(widget, args)
        local color1 = 'green'
        local color2 = 'green'
        local color3 = 'green'
        local color4 = 'green'
    
        if      args[1] > 90    then color1 = 'red'
        elseif  args[1] > 50    then color1 = 'orange' end
    
        if      args[2] > 90    then color2 = 'red'
        elseif  args[2] > 50    then color2 = 'orange' end

        if      args[3] > 90    then color3 = 'red'
        elseif  args[3] > 50    then color3 = 'orange' end
    
        if      args[4] > 90    then color4 = 'red'
        elseif  args[4] > 50    then color4 = 'orange' end
        return '<span color="#2222ff">⚙</span> <span color="'..color1..'">'..args[1]..'%</span> - <span color="'..color2..'">'..args[2]..'%</span> - <span color="'..color3..'">'..args[3]..'%</span> - <span color="'..color4..'">'..args[4]..'%</span>'
    end, 3)


--wi_cpuinf = widget({type = 'textbox', name = 'wi_cpuinf'})
--vicious.register(wi_cpuinf, vicious.widgets.cpuinf,
--    'FREQ <span color="green">${cpu0 mhz}M</span> - <span color="green">${cpu1 mhz}M</span> - <span color="green">${cpu2 mhz}M</span> - <span color="green">${cpu3 mhz}M</span>', 7)
-- }}}

-- {{{ Memory widget
wi_memory = widget({type = 'textbox', name = 'wi_memory'})
vicious.register(wi_memory, vicious.widgets.mem, 
    function(widget, args)
        local color1        = 'green'
        local color2        = 'green'
        local swap_report    = ''

        if      args[1] > 50 then color1 = 'yellow'
        elseif  args[1] > 85 then color1 = 'red' end

        if      args[5] > 50 then color2 = 'orange'
        elseif  args[5] > 85 then color2 = 'red' end

        if args[5] > 0 then
            --swap_report = 'SWAP <span color="'..color2..'">'..args[5]..'% ('..args[6]..'/'..args[7]..'M)</span>' end
            swap_report = 'SWAP <span color="'..color2..'">'..args[6]..'/'..args[7]..'M</span>' end
   --     

        --return 'RAM <span color="'..color1..'">'..args[1]..'% ('..args[2]..'/'..args[3]..'M)</span>'..swap_report
        return '<span color="#2222ff">RAM</span> <span color="'..color1..'">'..args[2]..'/'..args[3]..'M</span>'..swap_report
    end, 17)
-- }}}

-- {{{ File system widget
wi_fs = widget({type = 'textbox', name = 'wi_fs'})
vicious.register(wi_fs, vicious.widgets.fs,
    function(widget, args)
        local color1 = 'green'
        local color2 = 'green'

        return 
            '<span color="#2222ff">/</span> <span color="'..color1..'">'..args['{/ avail_gb}']..'G</span> | '..
            '<span color="#2222ff">/home</span> <span color="'..color2..'">'..args['{/home avail_gb}']..'G</span>'
    end, 181)
-- }}}

-- {{{ Network widget
wi_net = widget({type = 'textbox', name = 'wi_net'})
vicious.register(wi_net, vicious.widgets.net,
    function(widget, args)
        local eth_report    = ''
        local wlan_report   = ''
    
        if tonumber(args['{eth0 rx_mb}']) > 0 or tonumber(args['{eth0 tx_mb}']) > 0 then
            eth_report = '<span color="#2222ff">ETH0</span> <span color="green">▾'..args['{eth0 down_kb}']..'k</span> <span color="red">▴'..args['{eth0 up_kb}']..'k</span> (<span color="green">▾'..args['{eth0 rx_mb}']..'M</span> <span color="red">▴'..args['{eth0 tx_mb}']..'M</span>)' end
        if tonumber(args['{wlan0 rx_mb}']) > 0 or tonumber(args['{wlan0 tx_mb}']) > 0 then
            wlan_report = '<span color="#2222ff">WLAN0</span> <span color="green">▾'..args['{wlan0 down_kb}']..'k</span> <span color="red">▴'..args['{wlan0 up_kb}']..'k</span> (<span color="green">▾'..args['{wlan0 rx_mb}']..'M</span> <span color="red">▴'..args['{wlan0 tx_mb}']..'M</span>)' end

        return eth_report..wlan_report
    end, 2)
-- }}}

-- {{{ Battery widget
wi_bat = widget({type = "textbox", name = "wi_bat"})
vicious.register(wi_bat, vicious.widgets.bat,
    function(widget, args)
        local color2 = 'green'

        if      tonumber(args[2]) < 50 then color2 = 'orange'
        elseif  tonumber(args[2]) < 15 then color2 = 'red' end

        if args[1] == '↯' or args[1] == '⌁' then
            return '<span color="#2222ff">⚡</span> <span color="'..color2..'">'..args[2]..'%</span>'
        end

        return '<span color="#2222ff">⚡</span> <span color="'..color2..'">'..args[2]..'% ('..args[1]..' '..args[3]..')</span>'
    end, 61, 'BAT0')
-- }}}

-- {{{ Volume widget
--ic_volume = widget({ type = "imagebox" })
--ic_volume.image = image('~/.config/awesome/icons/volume.png')

--wi_volume = widget({type = "textbox", name = "wi_volume"})
--vicious.register(wi_volume, vicious.widgets.volume,
--    '<span color="#0000ff">VOL</span> <span color="#00aa00">$1%</span>', 13, 'Master')
--wi_volume:buttons(awful.util.table.join(
--   awful.button({ }, 4, function () awful.util.spawn("amixer -q set Master 2dB+", false) end),
--   awful.button({ }, 5, function () awful.util.spawn("amixer -q set Master 2dB-", false) end)
--))
-- }}}

-- {{{ Mail widget
wi_mail_google  = widget({ type = "textbox"})
wi_mail_eth     = widget({ type = "textbox"})
wi_mail_mailoo  = widget({ type = "textbox"})

vicious.register(wi_mail_google, vicious.widgets.mdir,
    function(widget, args)
        local color = 'red'

        if tonumber(args[1]) > 0 then color = 'green' end
        
        return '<span color="#2222ff">✉ GMAIL</span> <span color="'..color..'">'..args[1]..'</span>'
    end, 101, {'~/mail/gmail'}
)

vicious.register(wi_mail_mailoo, vicious.widgets.mdir,
    function(widget, args)
        local color = 'red'

        if tonumber(args[1]) > 0 then color = 'green' end
        
        return '<span color="#2222ff">✉ MAILOO</span> <span color="'..color..'">'..args[1]..'</span>'
    end, 113, {'~/mail/mailoo'}
)
-- }}}

-- {{{ HDD temperature widget
--wi_hdtemp = widget({type='textbox', name='wi_hdtemp'})
--vicious.register(wi_hdtemp, vicious.widgets.hddtemp,
--    "♨ <span color=\"#5555ff\">${/dev/sda}℃</span>", 59)
-- }}}

-- {{{ Load widget
--wi_load = widget({type='textbox', name='wi_load'})
--vicious.register(wi_load, vicious.widgets.uptime,
--    'LOAD <span color="blue">$4/$5/$6</span>', 53)
-- }}}

-- {{{ ACPI thermal widget
wi_thermal = widget({type='textbox', name='wi_thermal'})
vicious.register(wi_thermal, vicious.widgets.thermal,
    '<span color="#2222ff">♨</span> <span color="green">$1℃</span>', 47, 'thermal_zone0')
-- }}}

-- {{{ Pacman widget
wi_pacman = widget({type='textbox', name='wi_pacman'})
vicious.register(wi_pacman, vicious.widgets.pkg,
    function(widget, args)
        color = 'red'
        if args[1] > 0 then color = 'green' end

        return '<span color="#2222ff">PKG</span> <span color="'..color..'">'..args[1]..'</span>'
    end, 1861, 'Arch')
-- }}}

-- {{{ Keyboard widget
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { "fr", "us", "dvorak" }
kbdcfg.current = 1
kbdcfg.widget = widget({ type = "textbox"})
kbdcfg.widget.text = '<span color="#2222ff">⌨</span> <span color="green">' .. kbdcfg.layout[kbdcfg.current] .. '</span>'
kbdcfg.switch = function ()
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    local t = '<span color="#2222ff">⌨</span> <span color="green">' .. kbdcfg.layout[kbdcfg.current] .. '</span>'
    kbdcfg.widget.text = t
    os.execute( kbdcfg.cmd..' '..kbdcfg.layout[kbdcfg.current] )
end
-- }}}

-- Wifi widget {{{
wi_wireless = widget({type='textbox', name='wi_wireless'})
vicious.register(wi_wireless, vicious.widgets.wifi,
    function(widget, args)
        color = '#ff0000'
        if args['{linp}'] > 0 then color = 'green' end
        if args['{ssid}'] == 'N/A' then return '' end

        return '<span color="#2222ff">WIFI</span> <span color="'..color..'">'..args['{ssid}']..' ('..args['{linp}']..')</span>'
    end, 31, 'wlan0')
-- }}}

--  Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () kbdcfg.switch() end)
))


-- TODO
--If you are paranoid about battery usage, and you would prefer if wicked didn't run commands in the background all the time while you are on battery power, you could temporarily suspend all wicked updates by using "wicked.suspend()" in a keybinding. You can reactivate everything that was suspended by using "wicked.activate()".
    
-- Create a wibox for each screen and add it
wibox_top    = {}
wibox_bottom = {}
mypromptbox  = {}
mylayoutbox  = {}

-- {{{ Tag list
mytaglist         = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
-- }}}

-- {{{ Taskbar
tasklist = {}
tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)
-- }}}

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist(function(c)
        return awful.widget.tasklist.label.currenttags(c, s)
    end, tasklist.buttons)


    -- Create the wiboxes
    wibox_top[s]    = awful.wibox({ position = "top", screen = s })
    wibox_bottom[s] = awful.wibox({ position = "bottom", screen = s })

    wibox_bottom[s].widgets = { tasklist[s], layout = awful.widget.layout.horizontal.leftright }
    wibox_top[s].widgets = {
        {
            --launcher,
            mylayoutbox[s],
            separator, mytaglist[s],
            separator, kbdcfg.widget,
            separator, wi_memory,
            --separator, wi_cpuinf,
            separator, wi_fs,
            separator, wi_bat,
            --separator, wi_volume,
            separator, wi_thermal,
            separator, wi_pacman,
            --wi_gmail,
            --separator, wi_mdir,
            --separator, wi_load,
            --separator, wi_hdtemp,
            separator, wi_mail_google,
            separator, wi_mail_mailoo,
            separator, mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        wi_clock, separator,
        s == 1 and wi_systray or nil,
        separator, wi_wireless,
        separator, wi_net,
        separator, wi_cpu,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Global key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    --awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "Escape", vicious.suspend()),
    awful.key({ modkey, "Shift"   }, "Escape", vicious.activate()),

    awful.key({ modkey,           }, "Page_Down",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Page_Up",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",           function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k",           function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j",           function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k",           function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Standard program
    awful.key({ modkey,           }, "Return",  function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "t",       function () awful.util.spawn("uzbl-browser") end),
    awful.key({ },                   "Print",   function () awful.util.spawn("scrot -e 'mv $f ~/ 2>/dev/null'") end),
    awful.key({ modkey,           }, "F5", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "Up",    function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Down",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up",    function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "Down",  function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Shift"   }, "Left",  function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    --awful.key({ modkey },            "r",     function () awful.util.spawn("$(dmenu_path | dmenu -b -nb '#000022' -nf '#FFFFFF' -sb '#000077' -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -p 'Launch: ')") end),
    awful.key({modkey  }, "r", function()
        awful.util.spawn_with_shell( "exe=`dmenu_run -b -nf '#ffffff' -nb '#000022' -sf '#ffff00' -sb '#000077' -p 'Launch: '` && exec $exe")
    end),

    awful.key({ modkey },            "x",     function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),

    -- Scratch drop
    awful.key({ modkey }, "BackSpace", function () scratch.drop("urxvt", "bottom", "center", 0.9, 0.4, true) end)
)
-- }}}

-- {{{ Client keybindings
-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey            }, "b",      function ()  wibox_top[mouse.screen].visible = not wibox_top[mouse.screen].visible end),
    awful.key({ modkey,           }, "F11",    function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "F4",     function (c) c:kill()                         end),
    awful.key({ modkey,           }, "F5",     function (c) c:redraw()                      end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end


clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    -- Set Uzbl to always map on tags number 2 of screen 1.
     { rule = { class = "Uzbl" },
       properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c)
    c.border_color = beautiful.border_focus 
    c.opacity = 1
end)
client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    --c.opacity = 0.7
end)
-- }}}

-- Timer called every minute {{{
clock_timer = timer { timeout = 60 }
clock_timer:add_signal('timeout', function()
    wi_clock.text = '<span color="#ffff00">⌚ '..os.date("%a %d %b | %H:%M")..'</span>' end)
clock_timer:start()
-- }}}

-- Autorun programs {{{
autorun = true
autorunApps = { 
   "urxvt"
}

if autorun then
   for app = 1, #autorunApps do
       awful.util.spawn(autorunApps[app])
   end
end
-- }}}
