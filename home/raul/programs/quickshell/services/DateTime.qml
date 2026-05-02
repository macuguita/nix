pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    property alias date: clock.date

    function format(fmt) {
        return Qt.formatDateTime(clock.date, fmt)
    }
}