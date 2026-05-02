pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property list<NotificationObj> notifications: []

    NotificationServer {
        id: server

        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;

            root.notifications.push(notiComponent.createObject(root, {
                visible: true,
                data: notif
            }));
        }
    }

    component NotificationObj: QtObject {
        id: notification

        required property Notification data
        property bool visible

        readonly property Timer timer: Timer {
            running: true
            interval: notification.data.expireTimeout > 0 ? notification.data.expireTimeout : 5000
            onTriggered: {
                notification.remove();
            }
        }

        function remove() {
            root.notifications.splice(root.notifications.indexOf(notification), 1);
        }
    }

    Component {
        id: notiComponent

        NotificationObj {}
    }
}
