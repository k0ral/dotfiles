{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

-- {{{ Imports
import           XMonad
import qualified XMonad.Actions.ConstrainedResize  as Sqr
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.CycleWS
import           XMonad.Actions.DwmPromote
import           XMonad.Actions.FindEmptyWorkspace
import           XMonad.Actions.FloatKeys
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.GridSelect
import           XMonad.Actions.NoBorders
import           XMonad.Actions.Warp
import           XMonad.Config.Azerty
import           XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.FadeInactive
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.Accordion
import           XMonad.Layout.Decoration
import           XMonad.Layout.Grid
import           XMonad.Layout.Maximize
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.StackTile
import           XMonad.Layout.Tabbed
import           XMonad.Layout.WindowNavigation
import           XMonad.Prompt
--import XMonad.Prompt.RunOrRaise
--import XMonad.Prompt.Shell
import           XMonad.Prompt.XMonad
import qualified XMonad.StackSet                   as W
import           XMonad.Util.EZConfig              (additionalKeys)
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run                   (spawnPipe)

import qualified Data.Map                          as M
import           Data.Monoid

import           System.Exit
import           System.IO
-- }}}

-- {{{ Applications
myTerminal           = "termite -e \"/bin/sh -c '" ++ myShell ++ "'\""
myShell              = "abduco -c /tmp/abduco-`cat /dev/urandom | tr -dc A-Za-z0-9_ | head -c8` fish"
myBrowser            = "firefox"
-- }}}

-- {{{ Workspaces & layouts
myWorkspaces =  ["1:movie", "2:music", "3:dev", "4:web"] ++ map show [5..9]

devLayout     = avoidStruts . maximize . smartBorders . windowNavigation $ tiled
movieLayout   =               maximize . noBorders    . windowNavigation $ Full
webLayout     = avoidStruts . maximize . smartBorders . windowNavigation $ Full
defaultLayout = avoidStruts . maximize . smartBorders . windowNavigation $ Grid ||| tiled ||| Mirror tiled ||| myTabbed ||| Full ||| Accordion

tiled = Tall nmaster delta ratio
  where
    nmaster = 1        -- Windows in the master pane
    ratio   = 1/2      -- Proportion of screen occupied by master pane
    delta   = 3/100    -- Percent of screen to increment by when resizing panes
stack    = StackTile 1 (3/100) (1/2)
myTabbed = tabbed shrinkText tabTheme

tabTheme = Theme {
    activeColor         = "#000077",
    inactiveColor       = "#000000",
    urgentColor         = "#770000",
    activeBorderColor   = "#000077",
    inactiveBorderColor = "#111111",
    urgentBorderColor   = "#777700",
    activeTextColor     = "#ffffff",
    inactiveTextColor   = "#aaaaaa",
    urgentTextColor     = "#ffff00",
    fontName            = "xft:Inconsolata:size=10",
    decoWidth           = 200,
    decoHeight          = 20,
    windowTitleAddons   = [],
    windowTitleIcons    = []}

myLayout = onWorkspace "1:movie" movieLayout .
           onWorkspace "3:dev"   devLayout .
           onWorkspace "4:web"   webLayout $
           defaultLayout
-- }}}


myBorderWidth        = 2
myNormalBorderColor  = "#000099"
myFocusedBorderColor = "#ffff00"

myFocusFollowsMouse = True

-- Scratchpad
scratchpads = [NS "termite"
                  ("termite -r scratchpad -t scratchpad -e \"bash -c '" ++ myShell ++ "'\"")
                  (title =? "scratchpad")
                  (customFloating $ W.RationalRect l t w h) ]
  where
    h = 0.4         -- terminal height
    w = 0.95        -- terminal width
    t = 1 - h       -- distance from top edge
    l = (1 - w)/2   -- distance from left edge

myModMask = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
myNumlockMask   = mod2Mask


-- {{{ Key bindings
myKeys = \c -> azertyKeys c `M.union` generalKeys c

generalKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [
    -- Spawn programs
    ((modm,                 xK_Return),     spawn $ XMonad.terminal conf),
    ((modm,                 xK_t),          spawn myBrowser),
    ((modm,                 xK_BackSpace),  namedScratchpadAction scratchpads "termite"),
    --((modm,                 xK_r),          spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    ((modm,                 xK_r),          spawn "dmenu_run -b -l 10 -p 'Execute'"),
    --((modm,                 xK_r),          shellPrompt mySP),
    --((modm .|. shiftMask,   xK_r ),         runOrRaisePrompt mySP),
    ((modm,                 xK_l),          spawn "slock"),
    ((modm,                 xK_x),          xmonadPrompt defaultXPConfig),
    ((modm,                 xK_F4),         kill1),

    -- Layouts
    ((modm,                 xK_space),      sendMessage NextLayout),
    ((modm .|. shiftMask,   xK_space),      setLayout $ XMonad.layoutHook conf),
    ((modm,                 xK_n),          refresh),
    ((modm,                 xK_v),          windows copyToAll),
    ((modm .|. shiftMask,   xK_v),          killAllOtherCopies),
    ((modm,                 xK_i),          withFocused $ \w -> tileWindow w (Rectangle 100 100 400 200) >> float w >> snapMove R Nothing w >> snapMove D Nothing w),

    -- Focus
    ((modm,                 xK_Tab),        windows W.focusDown),
    ((modm,                 xK_Page_Down),  windows W.focusDown),
    ((modm,                 xK_Page_Up),    windows W.focusUp),
    --((modm,                 xK_m),          windows W.focusMaster),
    -- ((modm,                 xK_u),          focusUrgent),
    ((modm,                 xK_g),          goToSelected defaultGSConfig),

    -- Swap focused window
    --((modm,                 xK_Return),     windows W.swapMaster),
    --((modm .|. shiftMask,   xK_j     ),     windows W.swapDown  ),
    --((modm .|. shiftMask,   xK_k     ),     windows W.swapUp    ),
    ((modm,                 xK_m),          dwmpromote),

    -- Resize
    ((modm,                 xK_Down),       sendMessage Shrink),
    ((modm,                 xK_Up),         sendMessage Expand),

    -- Push window back into tiling
    ((modm .|. shiftMask,   xK_t),          withFocused $ windows . W.sink),

    -- Number of windows in the master area
    ((modm .|. shiftMask,   xK_greater),    sendMessage (IncMasterN 1)),
    ((modm,                 xK_less),       sendMessage (IncMasterN (-1))),

    -- Workspaces/screens navigation
    ((modm,                 xK_Right),      nextWS),
    ((modm,                 xK_Left),       prevWS),
    ((modm,                 xK_Down),       nextScreen),
    ((modm,                 xK_Up),         prevScreen),

    ((modm .|. controlMask, xK_Right),      sendMessage $ Swap R),
    ((modm .|. controlMask, xK_Left ),      sendMessage $ Swap L),
    ((modm .|. controlMask, xK_Up   ),      sendMessage $ Swap U),
    ((modm .|. controlMask, xK_Down ),      sendMessage $ Swap D),

    ((modm .|. shiftMask,   xK_Right),      withFocused $ snapMove R Nothing),
    ((modm .|. shiftMask,   xK_Left ),      withFocused $ snapMove L Nothing),
    ((modm .|. shiftMask,   xK_Up   ),      withFocused $ snapMove U Nothing),
    ((modm .|. shiftMask,   xK_Down ),      withFocused $ snapMove D Nothing),


    ((modm,                 xK_e),          viewEmptyWorkspace),
    ((modm .|. shiftMask,   xK_e),          tagToEmptyWorkspace),

    -- Mouse
    ((modm,                 xK_o),          banish UpperLeft),

    ((modm,                 xK_z),          withFocused toggleBorder),
    ((modm,                 xK_F11),        withFocused (sendMessage . maximizeRestore)),

    ((modm,                 xK_Print),      spawn "scrot -e 'mv $f ~/'"),

    ((modm .|. shiftMask,   xK_q),          io exitSuccess),
    ((modm              ,   xK_F5),         spawn "xmonad --recompile; xmonad --restart")
    ]
-- }}}

-- {{{ Mouse bindings
-- You may also bind events to the mouse scroll wheel (button4 and button5)
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $ [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)),
    -- mod-button2, Raise the window to the top of the stack
    ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
    -- mod-button3, Set the window to floating mode and resize by dragging
    --, ((modm, button3), (\w -> focus w >> mouseResizeWindow w
    --                                   >> windows W.shiftMaster))
    ((modm, button3),               (\w -> focus w >> Sqr.mouseResizeWindow w False)),
    ((modm .|. shiftMask, button3), (\w -> focus w >> Sqr.mouseResizeWindow w True ))]
-- }}}


-- {{{ Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
-- floatingWindows = composeAll [
    -- className =? "Gimp"           --> doFloat]

ignoredWindows = composeAll [
    resource  =? "desktop_window" --> doIgnore]

moveToWorkspace = composeAll [
    resource =? "emacs"  --> doF (W.shift "3:dev") ]

manageScratchpad :: ManageHook
manageScratchpad = namedScratchpadManageHook scratchpads

onNewWindow =
    manageScratchpad <+>
    manageDocks <+>
    -- floatingWindows <+>
    ignoredWindows <+>
    moveToWorkspace
-- }}}

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

-- {{{ Status bar
statusBarPP = xmobarPP {
    ppCurrent           = xmobarColor "cyan" "",
    ppVisible           = wrap "(" ")",
    ppHidden            = (\i -> case i of
        "NSP" -> ""
        _     -> i),
    ppHiddenNoWindows   = const "",
    ppUrgent            = xmobarColor "red" "",
    ppSep               = " | ",
    ppWsSep             = " ",
    ppTitle             = xmobarColor "#7777ff" "" . shorten 30,
    ppOrder             = \(ws:_:_:_) -> [ws] }
-- }}}


-- Perform an arbitrary action each time xmonad starts or is restarted.
-- Used by, e.g., XMonad.Layout.PerWorkspace to initialize per-workspace layout choices.
myStartupHook = setWMName "LG3D"

myUrgencyHook = withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }


-- {{{ Entry point
main = do
    _ <- spawn myTerminal
    xmonad =<< statusBar "xmobar" statusBarPP (const (myModMask, xK_b)) myConfig

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
myConfig = myUrgencyHook $ defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    -- numlockMask        = myNumlockMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = onNewWindow,
    handleEventHook    = myEventHook,
    startupHook        = myStartupHook
    }
-- }}}
