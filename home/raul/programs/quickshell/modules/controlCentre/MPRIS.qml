import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Widgets
import Quickshell.Services.Mpris

import qs
import qs.components

Rectangle {
    id: root

    Layout.fillWidth: true
    implicitHeight: 200

    radius: 15
    color: Colors.mantle

    required property MprisPlayer player

    property real amplitude: root.player?.playbackState == MprisPlaybackState.Playing ? 2 : 0
    Behavior on amplitude {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutExpo
        }
    }

    FrameAnimation {
        running: root.player?.playbackState == MprisPlaybackState.Playing
        onTriggered: {
            root.player.positionChanged();
        }
    }

    property real progress: root.player?.positionSupported || false ? (root.player.position / root.player.length) : 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        RowLayout {
            ClippingRectangle {
                implicitWidth: 120
                implicitHeight: 120

                radius: 18
                clip: true
                color: root.player?.trackArtUrl != null ? "transparent" : Colors.crust

                Image {
                    id: background
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? "" // shut up qmlls yes i can

                    sourceSize.width: 512
                    sourceSize.height: 512
                }
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignHCenter
                Layout.margins: 10

                DefaultedText {
                    Layout.fillWidth: true

                    text: root.player?.trackTitle ?? ""

                    font.bold: true
                    elide: Text.ElideRight
                    color: Colors.text
                }

                DefaultedText {
                    Layout.fillWidth: true

                    text: root.player?.trackArtist ?? ""

                    elide: Text.ElideRight
                    color: Colors.text
                }
            }

            Control {
                implicitWidth: 50
                implicitHeight: 50

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player?.isPlaying)
                            root.player.pause();
                        else
                            root.player.play();
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: Colors.accent
                    radius: 180

                    Behavior on radius {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Icon {
                    anchors.centerIn: parent

                    color: Colors.base
                    font.pixelSize: 30

                    fill: 1

                    icon: root.player?.isPlaying ? "pause" : "play_arrow"
                }
            }
        }

        RowLayout {
            Icon {
                icon: "skip_previous"
                color: root.player?.canGoPrevious ? Colors.text : Colors.crust
                font.pixelSize: 25

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player.canGoPrevious)
                            root.player.previous();
                    }
                }
            }

            Canvas {
                id: canvas

                Layout.fillWidth: true
                implicitHeight: 20

                FrameAnimation {
                    running: true
                    onTriggered: {
                        canvas.frames++;
                        canvas.requestPaint();
                    }
                }

                property int frames: 0

                Rectangle {
                    id: inverseProgress

                    width: (1 - root.progress) * parent.width

                    height: 3
                    radius: 180

                    color: Colors.crust

                    x: (root.progress * parent.width)
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: handle

                    visible: root.player?.positionSupported || false

                    width: 6
                    height: 20
                    radius: 180
                    color: Colors.accent

                    x: (root.progress * parent.width) - 3
                }

                onPaint: {
                    var context = getContext("2d");

                    context.reset();

                    context.beginPath();
                    context.strokeStyle = Colors.accent;
                    context.lineWidth = 3;
                    context.lineCap = "round";

                    var xPad = 4;

                    var x = xPad;
                    var y = 0;
                    var frequency = 4.5;

                    if (root.amplitude < 0) {
                        context.lineTo(x + width + 6, y);
                    } else {
                        while (x < ((width + 6) * root.progress) - xPad) {
                            y = height / 2 + root.amplitude * Math.sin((x / frequency) + (frames / 60));
                            context.lineTo(x, y);
                            x = x + 1;
                        }
                    }

                    context.stroke();
                }
            }

            Icon {
                icon: "skip_next"
                color: root.player?.canGoNext ? Colors.text : Colors.crust
                font.pixelSize: 25

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player?.canGoNext)
                            root.player.next();
                    }
                }
            }
        }
    }
}
