import Quickshell
import Quickshell.Wayland
import QtQuick

import qs

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: window

        required property ShellScreen modelData
        screen: modelData

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        Image {
            anchors.fill: parent

            source: Settings.wallpaper
        }
    }
}
