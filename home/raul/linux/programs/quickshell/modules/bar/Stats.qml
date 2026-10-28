import Quickshell.Services.UPower
import Quickshell.Io
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.components

Rectangle {
    id: root

    property real memoryUsed: 0

    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight + 10

    radius: 180
    color: Colors.mantle

    ColumnLayout {
        id: layout
        anchors.centerIn: parent

        spacing: 10

        Item {
            implicitWidth: 30
            implicitHeight: 30

            CircularProgressBar {
                anchors.fill: parent
                icon: "memory_alt"
                filledColor: Colors.blue
                progress: root.memoryUsed
            }
        }

        Loader {
            active: UPower.displayDevice.isLaptopBattery

            sourceComponent: Item {
                implicitWidth: 30
                implicitHeight: 30

                CircularProgressBar {
                    anchors.fill: parent
                    filledColor: progress < 0.25 ? Colors.red : (progress < 0.5 ? Colors.yellow : Colors.green)
                    icon: `battery_android_${Math.round(progress * 6)}`

                    progress: UPower.displayDevice.percentage
                }
            }
        }

        Rectangle {
            id: ccButton

            implicitWidth: 30
            implicitHeight: 30
            radius: 180

            property bool hovered: false

            color: hovered ? Colors.surface2 : Colors.surface0
            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }

            Icon {
                anchors.centerIn: parent

                icon: "more_horiz"
                font.pixelSize: 22
                color: Colors.text
            }

            MouseArea {
                onEntered: ccButton.hovered = true
                onExited: ccButton.hovered = false

                Process {
                    id: ccProc
                    command: ["sh", "-c", "quickshell ipc call control_centre toggle"]
                }

                onClicked: {
                    ccProc.running = true;
                }

                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    Process {
        id: memoryProc

        // I really hate this but idk a better way to do it
        command: ["sh", "-c", "free | awk '/Mem:/{print($3/$2)}'"]

        running: true
        stdout: StdioCollector {
            onStreamFinished: root.memoryUsed = parseFloat(this.text.trim())
        }
    }

    Timer {
        interval: 3000 // 3 seconds
        running: true
        repeat: true

        onTriggered: {
            memoryProc.running = true;
        }
    }
}
