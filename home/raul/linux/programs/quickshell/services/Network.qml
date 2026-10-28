pragma Singleton

import Quickshell
import QtQuick

Singleton {

    component Connection: QtObject {
        required property string ssid
        required property bool active
    }
}
