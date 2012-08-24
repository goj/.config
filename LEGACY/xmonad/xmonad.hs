import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders

tiled = Tall nmaster delta ratio where
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

main = xmonad =<< myDzen myConfig

myDzen conf = statusBar ("dzen2 " ++ flags) dzenPP toggleStrutsKey conf
 where
    fg      = "'#a8a3f7'" -- n.b quoting
    bg      = "'#3f3c3d'"
    flags   = "-e 'onstart=lower' -w 1920 -ta l -fg " ++ fg ++ " -bg " ++ bg
    toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b)

myManageHook = composeAll . concat $
    [ [ stringProperty "WM_WINDOW_ROLE" =? "buddy_list" --> doShift "9" ]
    , [ className =? "Clipit" --> doCenterFloat ]
    ]

myConfig = ewmh $ defaultConfig
        { borderWidth = 1
        , focusedBorderColor = "red"
        , workspaces = map show [1..9]
        , modMask = mod4Mask
        , startupHook = setWMName "LG3D"
        , layoutHook = avoidStruts (tiled ||| Full ||| Mirror tiled)
        , manageHook = manageHook defaultConfig <+> manageDocks <+> myManageHook
        , terminal = "gnome-terminal"
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
        , ("M-p",      spawn "dmenu_run &")
        , ("M-r",      spawn "chromium --new-window")
        , ("M-b",      sendMessage ToggleStruts)
        , ("M-v",      spawn "x-run-here gvim")
        , ("M-g",      spawn "x-run-here gitg")
        , ("M-S-x",    spawn "xkill")
        , ("M-n",      spawn "x-run-here sakura &")
        , ("M-u",      focusUrgent)
        ]
