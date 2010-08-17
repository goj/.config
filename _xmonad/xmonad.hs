import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Config.Gnome

myManageHook = composeAll . concat $
    [ [ className =? "Pidgin" --> doShift "7:communication" ]
    , [ className =? "Skype" --> doShift "7:communication"]
    , [(className =? "Do") --> doIgnore] -- gnome do
    , [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat]
    ]
--xmproc <- spawnPipe "xmobar /usr/bin/xmobar /home/insane/.xmobarrc"
main = xmonad $ gnomeConfig
        { borderWidth = 2
        , focusedBorderColor = "red"
        , workspaces = map show [1..5] ++ ["6:mail", "7:communication", "8", "9"]
        , manageHook = manageDocks <+> manageHook gnomeConfig <+> myManageHook
        , layoutHook = avoidStruts $ layoutHook gnomeConfig
        , startupHook = setWMName "LG3D"
        , modMask = mod4Mask
        , terminal = "gnome-terminal"
        }
        `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
        `additionalKeysP`
        [ ("M-S-q",    spawn "xmonad --recompile && xmonad --restart")
        , ("M-S-l",    spawn "gnome-screensaver-command -l")
        , ("M-r",      spawn "chromium-browser --new-window")
        , ("M-p",      spawn "gnome-do")
        , ("M-v",      spawn "gvim")
        , ("M-S-x",    spawn "xkill")
        , ("M-u",      focusUrgent)
        , ("M1-M-S-l", spawn "gnome-session-save --gui --kill")
        ]
