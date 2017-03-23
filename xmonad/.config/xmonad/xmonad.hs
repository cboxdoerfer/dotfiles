import System.IO
import System.Exit
import XMonad

import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

import XMonad.Actions.FloatKeys
import XMonad.Actions.NoBorders
import XMonad.Actions.WindowGo
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook

import qualified XMonad.StackSet as W
import qualified Data.Map as M

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green = "#859900"

myLayoutHook = avoidStruts $ smartSpacing 4 $ smartBorders (tiled ||| Accordion ||| Full)
    where
        tiled = Tall 1 (3/100) (3/5)

myManageHook = scratchpadManageHook (W.RationalRect 0.2 0 0.6 0.5) <+> composeAll
    [
        className =? "Firefox" --> doShift "WEB"
        , className =? "DeaDBeeF" --> doShift "AV"
        , className =? "Thunderbird" --> doShift "MAIL"
        , className =? "lxqt-openssh-askpass" --> doFloat
        , title =? "Python Turtle Graphics" --> doFloat
        , manageDocks
    ]

myTerminal    = "gnome-terminal"
myEditor      = "nvim-wrapper"
myModMask     = mod4Mask -- Win key or Super_L
myBorderWidth = 2
myBorderColorNormal = "#586e75"
myBorderColorFocused = "#b58900"

myWorkspaces = ["GEN", "WEB", "DEV", "MAIL", "AV"] ++ map show [6..9]

-- | The xmonad key bindings. Add, modify or remove key bindings here.
--
-- (The comment formatting character is used when generating the manpage)
--
myKeybindings conf@XConfig {XMonad.modMask = modMask} = M.fromList $
    -- launching and killing programs
    [ ((modMask,               xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask .|. shiftMask, xK_Return), spawn myEditor) -- %! Launch editor
    , ((modMask,               xK_p     ), spawn "rofi -show drun") -- %! Launch rofi
    , ((modMask .|. shiftMask, xK_p     ), spawn "rofi -show run") -- %! Launch rofi
    , ((modMask,               xK_f     ), runOrRaiseMaster "fsearch" (className =? "fsearch")) -- %! Launch fsearch
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- Scratchpad
    --, ((modMask,               xK_minus), scratchpadSpawnAction conf)
    , ((modMask,               xK_minus), scratchpadSpawnActionCustom "st -n scratchpad -e tmux -2 attach")

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window
    , ((modMask,               xK_n     ), toggleWS ) -- %! Switch to last focused worksapce

    -- modifying the window order
    , ((modMask,               xK_s     ), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- copy windows
    , ((modMask, xK_v                   ), windows copyToAll) -- @@ Make focused window always visible
    , ((modMask .|. shiftMask, xK_v     ),  killAllOtherCopies) -- @@ Toggle window state back

    -- move float windows
    , ((modMask,                 xK_Up ), withFocused (keysMoveWindowTo (12,12) (0,0)))
    , ((modMask,               xK_Down ), withFocused (keysMoveWindowTo (1600 - 15, 900 - 37) (1,1)))
    , ((modMask,              xK_Right ), withFocused (keysMoveWindowTo (1600 - 15,12) (1,0)))
    , ((modMask,               xK_Left ), withFocused (keysMoveWindowTo (12, 900 - 37) (0,1)))


    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io exitSuccess) -- %! Quit xmonad
    , ((modMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
    ]
    ++

        -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        ++

        -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

main = do
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/config.hs"
    xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
        { terminal    = myTerminal
        , modMask     = myModMask
        , borderWidth = myBorderWidth
        , normalBorderColor = myBorderColorNormal
        , focusedBorderColor = myBorderColorFocused
        , workspaces  = myWorkspaces
        --, startupHook = myStartupHook
        , keys = myKeybindings
        , handleEventHook = mconcat [
            docksEventHook,
            handleEventHook defaultConfig
        ]
        , layoutHook  = myLayoutHook
        , manageHook  = myManageHook <+> manageHook defaultConfig
        , logHook     = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor blue "" . shorten 50
                , ppCurrent = xmobarColor "#c0c0c0" "" . wrap "" ""
                , ppSep = xmobarColor red "" "  :  "
                , ppUrgent = xmobarColor "#dc322f" ""
                --, ppLayout = xmobarColor yellow ""
                , ppLayout = const ""
        }
        }


