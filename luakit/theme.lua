--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "inconsolata normal 10"
theme.fg   = "#fff"
theme.bg   = "#003"

-- Genaral colours
theme.success_fg = "#0f0"
theme.loaded_fg  = "#33AADD"
theme.error_fg = "#ff0"
theme.error_bg = "#f00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FF0"

-- Notification colours
theme.notif_fg = "#fff"
theme.notif_bg = "#070"

-- Menu colours
theme.menu_fg                   = "#fff"
theme.menu_bg                   = "#000"
theme.menu_selected_fg          = "#ff0"
theme.menu_selected_bg          = "#00f"
theme.menu_title_bg             = "#000"
theme.menu_primary_title_fg     = "#f00"
theme.menu_secondary_title_fg   = "#660"

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#fff"
theme.sbar_bg         = "#003"

-- Downloadbar specific
theme.dbar_fg         = "#fff"
theme.dbar_bg         = "#000"
theme.dbar_error_fg   = "#F00"

-- Input bar specific
theme.ibar_fg           = "#ff0"
theme.ibar_bg           = "#000"

-- Tab label
theme.tab_fg            = "#888"
theme.tab_bg            = "#222"
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = "#fff"
theme.selected_bg       = "#000"
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = "#33AADD"
theme.loading_bg        = "#000"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#0F0"
theme.notrust_fg        = "#F00"

return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
