import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.components
import qs
import qs.services

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData
            screen: modelData

            WlrLayershell.layer: WlrLayer.Top
            color: "transparent"

            anchors {
                top: true
                left: true
                bottom: true
            }

            margins {
                right: 20 - 20 // - 20 for hyprland gaps
                left: 20
                top: 20
                bottom: 20
            }

            implicitWidth: 40

            Item {
                anchors.fill: parent

                Item {
                    anchors.top: parent.top

                    width: parent.width
                    height: parent.height / parent.children.length

                    Stats {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Item {
                    anchors.centerIn: parent
                    height: parent.height / parent.children.length

                    Workspaces {
                        screen: window.screen
                        anchors.centerIn: parent
                    }
                }

                Item {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height / parent.children.length

                    Rectangle {
                        width: parent.width
                        height: col.height + (10 * 2)
                        color: Colors.mantle
                        anchors.bottom: tray.top
                        anchors.bottomMargin: 10
                        radius: 180

                        Column {
                            id: col
                            anchors.centerIn: parent

                            DefaultedText {
                                font.family: "monospace"
                                font.italic: true
                                textFormat: Text.StyledText
                                text: DateTime.format("<b>hh</b><br\>mm")
                            }
                        }
                    }

                    Tray {
                        id: tray

                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
