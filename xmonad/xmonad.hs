{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
-- {{{ Imports
import qualified Data.Map                            as M
import           Data.Monoid
import           Data.Word
import           System.Exit
import           System.IO
import           XMonad
import qualified XMonad.Actions.ConstrainedResize    as Sqr
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
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.Grid
import           XMonad.Layout.MagicFocus
import           XMonad.Layout.Maximize
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.Spacing
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns
import           XMonad.Layout.WindowNavigation
import           XMonad.Prompt
import           XMonad.Prompt.XMonad
import qualified XMonad.StackSet                     as W
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Paste
import           XMonad.Util.Run                     (spawnPipe)
-- }}}

-- {{{ Applications
myTerminal           = "st -e /run/current-system/sw/bin/fish"
myShell              = "fish"
-- }}}

-- {{{ Workspaces & layouts
myWorkspaces =  ["1:movie", "2:music", "3:dev", "4:read"] <> map show [5..9]

myMaximize = maximizeWithPadding 0
commonLayoutModifiers = avoidStruts . myMaximize . smartBorders . mkToggle1 MIRROR

movieLayout   =                         smartBorders   . windowNavigation $ Full
devLayout     = commonLayoutModifiers . smartSpacing 3 . windowNavigation $ threeColumns
readLayout    = commonLayoutModifiers                  . windowNavigation $ threeColumns ||| myTabbed
defaultLayout = commonLayoutModifiers                  . windowNavigation $ threeColumns ||| Grid ||| myTabbed ||| simpleFloat

threeColumns = magicFocus $ ThreeColMid 1 (3/100) (1/2)
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
    fontName            = "xft:Hack:size=10:autohint=true:antialias=true",
    decoWidth           = 200,
    decoHeight          = 20,
    windowTitleAddons   = [],
    windowTitleIcons    = []}

myLayout = onWorkspace "1:movie" movieLayout $
           onWorkspace "3:dev"   devLayout $
           onWorkspace "4:read"  readLayout $
           defaultLayout
-- }}}


myBorderWidth        = 1
myNormalBorderColor  = "#000099"
myFocusedBorderColor = "cyan"

-- Scratchpad
scratchpads =
  [ NS "st" "st -c scratchpad -e /run/current-system/sw/bin/fish" (className =? "scratchpad") (customFloating $ W.RationalRect l t w h)
  , NS "volume" "st -c volume_scratchpad -e /bin/sh -c alsamixer" (className =? "volume_scratchpad") (customFloating $ W.RationalRect 0.68 0.02 0.3 0.3) ]
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
myKeymap = qwertyKeys <> generalKeys

qwertyKeys = do
  (i, k) <- zip myWorkspaces [1..]
  [ ("M-" <> show k, windows $ W.view i), ("M-S-" <> show k, windows $ W.shift i) ]

generalKeys = [
    -- Spawn programs
    ("M-<Return>",     spawn myTerminal),
    ("M-v",            namedScratchpadAction scratchpads "volume"),
    ("M-r",            spawn "dmenu_run -nb '#000033' -b -l 10 -p 'Execute'"),
    ("M-l",            spawn "i3lock-fancy"),
    ("M-x",            xmonadPrompt defaultXPConfig),
    ("M-<Print>",      spawn "scrot -e 'mv $f ~/'"),
    ("M-<F4>",         kill1),
    ("M-p",            spawn "/bin/sh -c 'mpc play $(mpc playlist -f \"%position% [[%artist% - ][%album% - ]%title%|%file%]\" | dmenu -b -nb \"#000033\" -p Play -i -l 20 | cut -d\" \" -f1)'"),

    -- Layouts
    ("M-<Space>",      sendMessage NextLayout),
    ("M-n",            refresh),
    -- ("M-_v),          windows copyToAll),
    ("M-S-v",          killAllOtherCopies),
    ("M-i",            withFocused $ \w -> tileWindow w (Rectangle 100 100 400 200) >> float w >> snapMove R Nothing w >> snapMove D Nothing w),
    ("M-m",            sendMessage $ Toggle MIRROR),
    ("M-S-t",          withFocused $ windows . W.sink),

    -- Focus
    ("M-<Tab>",        windows W.focusDown),
    ("M-<Page_Down>",  windows W.focusDown),
    ("M-<Page_Up>",    windows W.focusUp),
    -- ("M-_u),          focusUrgent),
    ("M-g",            goToSelected defaultGSConfig),

    -- Resize
    -- ("M-_Down),       sendMessage Shrink),
    -- ("M-_Up),         sendMessage Expand),

    -- Number of windows in the master area
    ("M-S-<Greater>",  sendMessage (IncMasterN 1)),
    ("M-<Less>",       sendMessage (IncMasterN (-1))),

    -- Workspaces/screens navigation
    ("M-<Right>",      nextWS),
    ("M-<Left>",       prevWS),
    ("M-<Down>",       nextScreen),
    ("M-<Up>",         prevScreen),

    -- Window navigation
    ("M-C-<Right>",    sendMessage $ Swap R),
    ("M-C-<Left>",     sendMessage $ Swap L),
    ("M-C-<Up>",       sendMessage $ Swap U),
    ("M-C-<Down>",     sendMessage $ Swap D),

    -- ("M-S-Right),      withFocused $ snapMove R Nothing),
    -- ("M-S-Left ),      withFocused $ snapMove L Nothing),
    -- ("M-S-Up   ),      withFocused $ snapMove U Nothing),
    -- ("M-S-Down ),      withFocused $ snapMove D Nothing),
    ("M-S-<Right>",    sendMessage $ Go R),
    ("M-S-<Left>",     sendMessage $ Go L),
    ("M-S-<Up>",       sendMessage $ Go U),
    ("M-S-<Down>",     sendMessage $ Go D),

    ("M-e",            viewEmptyWorkspace),
    ("M-S-e",          tagToEmptyWorkspace),

    -- Mouse
    ("M-o",            banish UpperLeft),

    ("M-z",            withFocused toggleBorder),
    ("M-<F11>",        withFocused (sendMessage . maximizeRestore)),

    ("M-<Insert>",     pasteSelection),

    ("M-S-q",          io exitSuccess),
    ("M-<F5>",         spawn "xmonad --recompile; xmonad --restart")
    ]
-- }}}

-- {{{ Mouse bindings
-- You may also bind events to the mouse scroll wheel (button4 and button5)
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster),
    -- mod-button2, Raise the window to the top of the stack
    ((modm, button2), \w -> focus w >> windows W.shiftMaster),
    -- mod-button3, Set the window to floating mode and resize by dragging
    --, ((modm, button3), (\w -> focus w >> mouseResizeWindow w
    --                                   >> windows W.shiftMaster))
    ((modm, button3),               \w -> focus w >> Sqr.mouseResizeWindow w False),
    ((modm .|. shiftMask, button3), \w -> focus w >> Sqr.mouseResizeWindow w True )]
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

manageScratchpad :: ManageHook
manageScratchpad = namedScratchpadManageHook scratchpads

onNewWindow =
    manageScratchpad <+>
    manageDocks <+>
    -- floatingWindows <+>
    ignoredWindows
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
    ppHidden            = \i -> case i of
        "NSP" -> ""
        _     -> i,
    ppHiddenNoWindows   = const "",
    ppUrgent            = xmobarColor "red" "",
    ppSep               = " | ",
    ppWsSep             = " ",
    ppTitle             = xmobarColor "#7777ff" "" . shorten 30,
    ppOrder             = \(ws:_:_:_) -> [ws] }
-- }}}


-- Perform an arbitrary action each time xmonad starts or is restarted.
-- Used by, e.g., XMonad.Layout.PerWorkspace to initialize per-workspace layout choices.
myStartupHook = setWMName "LG3D" >> checkKeymap myConfig myKeymap
myUrgencyHook = withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }


-- {{{ Entry point
main = do
    _ <- spawn myTerminal
    xmonad =<< statusBar "xmobar" statusBarPP (const (myModMask, xK_h)) myConfig

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
myConfig = myUrgencyHook $ defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = False,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    -- numlockMask        = myNumlockMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = \c -> mkKeymap c myKeymap,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = onNewWindow,
    handleEventHook    = myEventHook,
    startupHook        = myStartupHook
    }
-- }}}
