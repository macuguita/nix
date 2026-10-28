pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs
import qs.components

Slider {
    id: root

    property real gap: 5
    required property string icon

    Layout.fillWidth: true
    implicitWidth: 200
    implicitHeight: 50

    value: 0

    background: Item {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter

            height: root.height - 20
            width: root.width

            radius: 8

            color: Colors.mantle

            Icon {
                icon: root.icon
                color: Colors.text
                font.pixelSize: 20

                opacity: root.value < 0.9
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutExpo
                    }
                }

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    margins: 5
                }
            }
        }

        Rectangle {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            topLeftRadius: 8
            bottomLeftRadius: 8

            topRightRadius: root.value < 0.95 ? 2 : 8
            bottomRightRadius: root.value < 0.95 ? 2 : 8

            Behavior on topRightRadius {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.OutExpo
                }
            }
            Behavior on bottomRightRadius {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.OutExpo
                }
            }

            // anchors.fill: parent
            height: root.height - 14
            width: (root.visualPosition * root.width)
            Behavior on width {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            Icon {
                icon: root.icon
                color: Colors.base
                font.pixelSize: 20

                opacity: root.value > 0.9
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutExpo
                    }
                }

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    margins: 5
                }
            }

            color: Colors.accent
        }
    }

    handle: Rectangle {
        height: root.height
        width: 4

        radius: 180

        x: (root.visualPosition * root.width) + gap

        color: Colors.accent

        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutExpo
            }
        }
    }
}
