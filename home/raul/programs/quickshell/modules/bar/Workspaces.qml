import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Rectangle {
    id: root

    required property ShellScreen screen
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    property bool focusedMonitor: Hyprland.focusedMonitor?.id == root.monitor.id

    implicitHeight: pills.implicitHeight + 20
    implicitWidth: 30

    radius: 180

    color: Colors.mantle

    Column {
        id: pills
        anchors.centerIn: parent

        spacing: 10

        Repeater {
            model: 9
            delegate: Rectangle {
                id: pill

                required property int index

                property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => {
                    return w?.id === index + 1;
                }) ?? null // ?? null shuts up a warning by telling qml that yes, i do actually want this to be null

                property bool onCurrentMonitor: root.monitor == workspace?.monitor
                property bool focused: onCurrentMonitor && (workspace?.active || false)
                property bool occupied: workspace?.lastIpcObject.windows > 0 || false
                property bool active: workspace?.active || false

                width: 10
                radius: 20

                color: active ? (onCurrentMonitor ? Colors.text : Colors.overlay0) : (occupied ? Colors.overlay0 : Colors.surface0)

                states: [
                    State {
                        name: "WARNING"
                        when: pill.workspace?.urgent || false

                        PropertyChanges {
                            target: pill

                            // setting anything here makes the color change back when the animation stops
                            // why? i have no fucking clue
                            color: Colors.peach
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""
                        to: "WARNING"

                        SequentialAnimation {
                            loops: Animation.Infinite
                            ColorAnimation {
                                target: pill
                                property: "color"

                                from: pill.color
                                to: Colors.peach
                                easing.type: Easing.InOutSine
                                duration: 300
                            }
                            ColorAnimation {
                                target: pill
                                property: "color"

                                from: Colors.peach
                                to: pill.color
                                easing.type: Easing.InOutSine
                                duration: 300
                            }
                        }
                    }
                ]

                height: active ? 20 : 10
                Behavior on height {
                    NumberAnimation {
                        duration: 1000
                        easing.type: Easing.OutElastic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 500
                        easing.type: Easing.OutExpo
                    }
                }

                MouseArea {
                    anchors.fill: pill
                    cursorShape: parent.focused ? Qt.ArrowCursor : Qt.PointingHandCursor
                    onClicked: if (!parent.focused) {
                        Hyprland.dispatch(`workspace ${parent.index + 1}`);
                    }
                }
            }
        }
    }
}
