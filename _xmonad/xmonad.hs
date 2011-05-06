import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders

tiled = Tall nmaster delta ratio where
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

main = xmonad =<< dzen myConfig

myConfig = defaultConfig
        { borderWidth = 1
        , focusedBorderColor = "red"
        , workspaces = map show [1..9]
        , modMask = mod4Mask
        , startupHook = setWMName "LG3D"
        , layoutHook = avoidStruts (tiled ||| noBorders Full ||| Mirror tiled)
        , manageHook = manageHook defaultConfig <+> manageDocks
        , terminal = "sakura"
        }
        `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
        -- sane Q:W mapping to the screens
        `additionalKeys`
        [ ((mod4Mask .|. mask, key), f sc)
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]
        ]
        `additionalKeysP`
        [ ("M-S-q",    spawn "xmonad --recompile && xmonad --restart")
        , ("M-r",      spawn "chromium --new-window")
        , ("M-b",      sendMessage ToggleStruts)
        , ("M-v",      spawn "gvim")
        , ("M-S-x",    spawn "xkill")
        , ("M-u",      focusUrgent)
        ]
