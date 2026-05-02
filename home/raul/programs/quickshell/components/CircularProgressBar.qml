import QtQuick
import QtQuick.Shapes
import qs // not sure this is actually required but it makes the LSP work

Item {
    id: root

    // is this not a metaphor for the real world
    property real progress: 0

    property color emptyColor: Colors.surface0
    property color filledColor: Colors.accent
    property color textColor: Colors.text

    property real strokeWidth: 4

    property string icon: ""

    Behavior on progress {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutExpo
        }
    }

    Shape {
        id: shape
        anchors.fill: parent

        layer.enabled: true
        layer.samples: 8

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.emptyColor
            strokeWidth: root.strokeWidth

            PathAngleArc {
                centerX: shape.width / 2
                centerY: shape.height / 2
                radiusX: Math.min(centerX, centerY) - root.strokeWidth / 2
                radiusY: Math.min(centerX, centerY) - root.strokeWidth / 2

                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.filledColor
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: shape.width / 2
                centerY: shape.height / 2
                radiusX: Math.min(centerX, centerY) - root.strokeWidth / 2
                radiusY: Math.min(centerX, centerY) - root.strokeWidth / 2

                startAngle: 270
                sweepAngle: (root.progress * 360)
            }
        }
    }

    Icon {
        id: iconComponent
        icon: parent.icon

        font.pixelSize: 18
        font.weight: 400
        anchors.centerIn: parent
        color: root.filledColor

        opacity: 1
        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }

    DefaultedText {
        id: percentageText
        anchors.centerIn: parent

        text: Math.round(parent.progress * 100) + "%"
        color: parent.textColor
        font.pixelSize: 8

        opacity: 0
        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            percentageText.opacity = 1;
            iconComponent.opacity = 0;
        }

        onExited: {
            percentageText.opacity = 0;
            iconComponent.opacity = 1;
        }
    }
}
