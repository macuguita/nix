import QtQuick
import QtQuick.Layouts

import qs

Rectangle {
    id: root

    Layout.fillWidth: true
    implicitHeight: 64

    radius: 15
    color: Colors.mantle

    RowLayout {
        anchors.centerIn: parent
    }
}
