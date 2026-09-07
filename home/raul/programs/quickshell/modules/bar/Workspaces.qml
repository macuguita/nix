import QtQuick
import Quickshell
import Quickshell.Io
import qs

Rectangle {
    id: root

    required property ShellScreen screen

    // All workspaces, parsed from `niri msg --json workspaces`.
    property var workspaces: []

    function workspaceAt(index) {
        const list = root.workspaces;
        for (let i = 0; i < list.length; ++i) {
            const ws = list[i];
            if (ws.output === root.screen.name && ws.idx === index) {
                return ws;
            }
        }
        return null;
    }

    Process {
        id: refreshProc

        command: ["niri", "msg", "--json", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim();
                if (text === "") return;
                try {
                    root.workspaces = JSON.parse(text);
                } catch (e) {
                    // niri not ready yet, keep the old list
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: refreshProc.running = true
    }

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

                readonly property var workspace: root.workspaceAt(index + 1)
                readonly property bool exists: pill.workspace !== null
                readonly property bool focused: pill.exists && pill.workspace.is_focused
                readonly property bool active: pill.exists && pill.workspace.is_active
                readonly property bool occupied: pill.exists && !pill.workspace.is_active
                readonly property bool urgent: pill.exists && pill.workspace.is_urgent

                width: 10
                radius: 20

                color: pill.focused ? Colors.text
                     : (pill.active || pill.occupied) ? Colors.overlay0
                     : Colors.surface0

                states: [
                    State {
                        name: "WARNING"
                        when: pill.urgent

                        PropertyChanges {
                            target: pill
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

                height: pill.active ? 20 : 10
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

                Process {
                    id: focusProc

                    command: ["niri", "msg", "action", "focus-workspace", (index + 1).toString()]
                }

                MouseArea {
                    anchors.fill: pill
                    cursorShape: pill.focused ? Qt.ArrowCursor : Qt.PointingHandCursor
                    onClicked: if (!pill.focused) focusProc.running = true
                }
            }
        }
    }
}
