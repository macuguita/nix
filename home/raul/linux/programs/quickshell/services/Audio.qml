pragma Singleton

import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

Singleton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property PwNode defaultSink: Pipewire.defaultAudioSink

    property real volume: defaultSink?.audio?.volume ?? 0
    property bool muted: defaultSink?.audio?.muted ?? false

    function setVolume(value: real): void {
        if (defaultSink?.ready && defaultSink?.audio) {
            defaultSink.audio.muted = false;
            defaultSink.audio.volume = value;
        }
    }
}
