import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Widgets

import qs
import qs.services
import qs.components

LazyLoader {
    active: NotificationReceiver.notifications.length > 0

    PanelWindow {
        id: window
        screen: Quickshell.screens[2]
        WlrLayershell.layer: WlrLayer.Top

        color: "transparent"
        exclusiveZone: 0 // This is an overlay, dont exclude anything

        implicitWidth: notifications.implicitWidth + 20 * 2
        implicitHeight: notifications.implicitHeight + 20 * 2

        anchors {
            top: true
            right: true
        }

        Column {
            id: notifications
            spacing: 10

            anchors.centerIn: parent

            Repeater {
                model: NotificationReceiver.notifications

                delegate: Item {
                    id: item
                    required property NotificationReceiver.NotificationObj modelData

                    implicitWidth: bg.width
                    implicitHeight: bg.height

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if (item.modelData.data.actions.length === 0) {
                                item.modelData.dismiss();
                            }

                            if (item.modelData.data.actions.length === 1) {
                                item.modelData.data.actions[0].invoke();
                            }
                        }
                    }

                    RectangularShadow {
                        anchors.fill: bg
                        radius: bg.radius

                        blur: 10
                        spread: 1

                        color: "#33000000"
                    }

                    Rectangle {
                        id: bg

                        implicitWidth: content.width + 30
                        implicitHeight: content.height + 30

                        radius: 18
                        color: Colors.base

                        RowLayout {
                            id: content

                            anchors.centerIn: parent

                            width: 500
                            height: text.height + 20

                            spacing: 15

                            ClippingRectangle {
                                Layout.preferredWidth: parent.height
                                Layout.preferredHeight: parent.height

                                radius: bg.radius
                                clip: true
                                color: item.modelData.data.image != null ? "transparent" : Colors.crust

                                Image {
                                    id: background
                                    anchors.fill: parent
                                    source: item.modelData.data.image ?? "" // shut up qmlls yes i can

                                    smooth: true

                                    sourceSize.width: 512
                                    sourceSize.height: 512
                                }
                            }

                            Column {
                                id: text

                                Layout.fillWidth: true

                                DefaultedText {
                                    text: item.modelData.data.summary
                                    font.pixelSize: 20
                                    wrapMode: Text.Wrap

                                    font.family: "monospace"
                                    font.bold: true

                                    width: parent.width
                                }

                                DefaultedText {
                                    text: item.modelData.data.body
                                    wrapMode: Text.Wrap

                                    width: parent.width

                                    font.family: "monospace"
                                    font.pixelSize: 14
                                    font.italic: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
