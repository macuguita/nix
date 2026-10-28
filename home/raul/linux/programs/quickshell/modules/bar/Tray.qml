import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls

import qs
import qs.components

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: Math.max(tray.height, 20) + 20

    color: Colors.mantle
    radius: 180

    Column {
        id: tray
        anchors.centerIn: parent

        spacing: 10

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem

                required property SystemTrayItem modelData

                width: 20
                height: 20

                IconImage {
                    anchors.fill: parent
                    source: {
                        let icon = trayItem.modelData.icon;

                        if (icon.includes("?path=")) {
                            const [name, path] = icon.split("?path=");
                            icon = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`);
                        }

                        return icon;
                    }

                    asynchronous: true
                }

                property bool hovered: false

                QsMenuAnchor {
                    id: anchor
                    anchor.item: trayItem
                    menu: trayItem.modelData.menu
                }

                ToolTip.delay: 1000
                ToolTip.text: trayItem.modelData.tooltipTitle
                ToolTip.visible: hovered

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        if (mouse.button == Qt.LeftButton) {
                            trayItem.modelData.activate();
                        } else if (mouse.button == Qt.RightButton) {
                            anchor.open();
                        } else if (mouse.button == Qt.MiddleButton) {
                            trayItem.modelData.secondaryActivate();
                        }
                    }
                }
            }
        }
    }
}
