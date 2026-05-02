import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs
import qs.components
import qs.services

Scope {
    id: root
    property bool open: false

    IpcHandler {
        target: "control_centre"
        function toggle() {
            root.open = !root.open;
        }
    }

    LazyLoader {
        active: root.open

        PanelWindow {
            id: controlCentre

            WlrLayershell.layer: WlrLayer.Top

            color: "transparent"
            exclusiveZone: 0

            // Fullscreen so we can catch outside clicks
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            // Dismiss when clicking outside the panel rectangle
            MouseArea {
                anchors.fill: parent
                onClicked: mouse => {
                    if (!background.contains(mapToItem(background, mouse.x, mouse.y))) {
                        root.open = false;
                    }
                }
            }

            RectangularShadow {
                anchors.fill: background
                radius: background.radius

                blur: 20
                spread: 3

                color: "#33000000"
            }

            Rectangle {
                id: background

                width: 450
                height: 500

                x: 20
                y: 20

                color: Colors.base
                radius: 20
            }

            Column {
                x: background.x + 20
                y: background.y + 20
                width: background.width - 40
                height: background.height - 40

                spacing: 10

                RowLayout {
                    width: parent.width
                    MPRIS {
                        player: Mpris.players.values[0] ?? null
                    }
                }

                GridLayout {
                    width: parent.width
                    columns: 2

                    rowSpacing: 10
                    columnSpacing: 10

                    NetworkWidget {}
                    NightLightWidget {}
                }

                BrightnessSlider {}

                BigSlider {
                    id: volumeSlider

                    width: parent.width

                    value: Audio.volume
                    icon: Audio.muted || Audio.volume == 0 ? "volume_off" : "volume_up"

                    onMoved: () => {
                        Audio.setVolume(value);
                    }
                }
            }
        }
    }
}
