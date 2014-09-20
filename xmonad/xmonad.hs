--
-- Daniel McCain's xmonad configuration file
--

import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- For Mod+Left/Right:
import XMonad.Actions.CycleWS

-- For dzen2:
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts)
import XMonad.Hooks.UrgencyHook
import System.IO (hPutStrLn)

import XMonad.Hooks.SetWMName

-- Layouts:
import XMonad.Layout.Cross

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
myTerminal :: String
myTerminal = "urxvt"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Width of the window border in pixels.
myBorderWidth = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces :: [String]
myWorkspaces = ["1:main","2","3","4","5","6","7","8","9"]

-- Colors
blue = "#3B84A4"
lightBlue = "#81befb"
darkBlue = "#295d72"
grey = "#909090"
lightGrey = "#606060"
darkGrey = "#1a1a1a"
pink = "#fabada"
red = "#ff0000"

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor :: String
myNormalBorderColor = lightGrey

myFocusedBorderColor :: String
myFocusedBorderColor = blue

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- Launch dmenu
    , ((modm, xK_p), spawn "dmenu_run")

    -- Launch gmrun
    --, ((modm .|. shiftMask, xK_p), spawn "gmrun")

    -- Close focused window
    , ((modm .|. shiftMask, xK_c), kill)

    -- Rotate through the available layout algorithms
    , ((modm, xK_space), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm, xK_n), refresh)

    -- Move focus to the next window
    , ((modm, xK_Tab), windows W.focusDown)

    -- Move focus to the next window
    , ((modm, xK_j), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm, xK_k), windows W.focusUp)

    -- Move focus to the master window
    , ((modm, xK_m), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modm, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)

    -- Shrink the master area
    , ((modm, xK_h), sendMessage Shrink)

    -- Expand the master area
    , ((modm, xK_l), sendMessage Expand)

    -- Push window back into tiling
    , ((modm, xK_t), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm, xK_comma), sendMessage $ IncMasterN 1)

    -- Deincrement the number of windows in the master area
    , ((modm, xK_period), sendMessage $ IncMasterN (-1))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm, xK_b), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q), io exitSuccess)

    -- Restart xmonad
    , ((modm, xK_q),
        spawn "killall -9 conky; xmonad --recompile; xmonad --restart")

    -- Lock screen
    , ((modm .|. shiftMask, xK_x), spawn "xscreensaver-command --lock")
    , ((modm, xK_Left), prevWS)
    , ((modm, xK_Right), nextWS)
    , ((modm, xK_Up), nextScreen)
    , ((modm, xK_Down), prevScreen)
    , ((modm .|. shiftMask, xK_Left ), shiftToPrev)
    , ((modm .|. shiftMask, xK_Right), shiftToNext)
    , ((modm .|. shiftMask .|. controlMask, xK_Left),  shiftToPrev >> prevWS)
    , ((modm .|. shiftMask .|. controlMask, xK_Right), shiftToNext >> nextWS)

    -- Volume control:
    {- /usr/include/X11/XF86keysym.h:
    #define XF86XK_AudioLowerVolume  0x1008FF11  /* Volume control down       */
    #define XF86XK_AudioMute         0x1008FF12  /* Mute sound from the system*/
    #define XF86XK_AudioRaiseVolume  0x1008FF13  /* Volume control up         */
    #define XF86XK_AudioPlay         0x1008FF14  /* Start playing of audio >  */
    #define XF86XK_AudioStop         0x1008FF15  /* Stop playing audio        */
    #define XF86XK_AudioPrev         0x1008FF16  /* Previous track            */
    #define XF86XK_AudioNext         0x1008FF17  /* Next track                */
    -}
    , ((0, 0x1008FF11), spawn "exec amixer set Master 5%- unmute")
    -- , ((0, 0x1008FF12), spawn "exec amixer set Master mute")
    , ((0, 0x1008FF12), spawn "exec amixer set Master toggle")
    , ((0, 0x1008FF13), spawn "exec amixer set Master 5%+ unmute")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                      >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ tiled ||| Mirror tiled ||| simpleCross ||| Full
  where
     -- Default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
-- The left side seems to be the resource, and the right side the className
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    -- , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    ] <+> manageDocks

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

--
-- Loghook
--
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        -- ppCurrent = dzenColor FONTCOLOR BACKGROUNDCOLOR . type
        -- ppCurrent = dzenColor FONTCOLOR BACKGROUNDCOLOR . wrap SYMBOLS
        ---- where type =
        ------ wrap "<" ">" -- surrounds the window number with these symbols
        ------ pad -- marks window with a uniform color
        ppCurrent = dzenColor lightBlue "" . wrap "<" ">"

        -- How to display other workspaces which contain windows
        -- First color is text color; second color is square color
        , ppHidden = dzenColor blue "" . pad

        -- How to display other workspaces with no windows
        -- First color is text color; second color is square color
        , ppHiddenNoWindows = dzenColor lightGrey "" . pad

        -- How to display the current layout name
        , ppLayout = dzenColor blue ""

        -- If a window on another workspace needs my attention, color it
        , ppUrgent = dzenColor red "" . dzenStrip . wrap ">" "<"
        -- , ppUrgent = wrap (dzenColor "#ff0000" "" "{") (dzenColor "#ff0000" "" "}"    ) . pad

        -- Shorten if it goes over 100 characters
        , ppTitle = shorten 100
        -- , ppTitle           = wrap "^fg(#909090)[ " " ]^fg()" . shorten 40

        -- No separator between workspaces
        , ppWsSep = ""

        -- Put a few spaces between each object
        , ppSep = " | "

        , ppOutput = hPutStrLn h

        -- , ppVisible = wrap "[" "]"
    }

--
-- StatusBars
--
-- Resolution: 1280x800
font :: String
font = "inconsolata-11"

yCoord :: String
yCoord = "0"

xCoord :: String
xCoord = "0"

dzenWidth :: String
dzenWidth = "800"

dzen2Bar :: String
dzen2Bar = "dzen2 -x " ++ xCoord ++ " -y " ++ yCoord ++ " -w " ++ dzenWidth ++
    " -ta l -fn " ++ font

monitorWidth :: Int
monitorWidth = 1280

conkyWidth :: String
conkyWidth = show $ monitorWidth - read dzenWidth

conkyXcoord :: String
conkyXcoord = show $ read xCoord + read dzenWidth

conkyBar :: String
conkyBar = "conky -c /home/USER/.xmonad/conky_dzen | " ++
	"dzen2 -x " ++ conkyXcoord ++ " -y " ++ yCoord ++ " -w " ++ conkyWidth ++
    " -ta r -fg '" ++ lightBlue ++ "'" ++ " -fn " ++ font
-- For size debugging:
-- conkyBar = "conky -c /home/USER/.xmonad/conky_dzen | dzen2 -x 900 -y 0" ++
--     "-w 380 -ta r -bg '#fabada' -fg '#3b84a4'"

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"
--myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    dzenLeft <- spawnPipe dzen2Bar
    dzenRigth <- spawnPipe conkyBar
--    -- could be: spawn "conky -c ~/.dzen_conkyrc | dzen2 -options"
--    spawnToDzen "conky -c ~/.dzen_conkyrc" myRightBar
--    dzenRigth <- spawnPipe conkyBar

    --xmonad $ withUrgencyHook NoUrgencyHook $ defaults
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
        {
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
            -- key bindings
            keys               = myKeys,
            mouseBindings      = myMouseBindings,
            -- hooks, layouts
            layoutHook         = myLayout,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            --logHook            = myLogHook,
            logHook            = myLogHook dzenLeft,
            startupHook        = myStartupHook
        }
