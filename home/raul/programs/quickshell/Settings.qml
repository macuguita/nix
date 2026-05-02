// TODO: Nix substitutions

pragma Singleton

import Quickshell

Singleton {
    property string face: "file://" + Quickshell.env("HOME") + "/.face"
    property string wallpaper: "file://" + Quickshell.env("HOME") + "/.wallpaper"

    property bool hasBrightnessControl: true
}
