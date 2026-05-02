import Quickshell.Io
import QtQuick
import qs.components

BigSlider {
    id: root

    width: parent.width

    Process {
        id: applyProc
    }

    Process {
        id: readProc
        command: ["sh", "-c", "ddcutil getvcp 10"]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const textStr = text.trim();

                // Extract current brightness value
                const match = textStr.match(/current value\s*=\s*(\d+)/i);

                if (!match)
                    return;

                const brightness = parseInt(match[1]);

                // DDC is always 0–100
                root.value = brightness / 100.0;
            }
        }
    }

    icon: value < 0.25
        ? "brightness_5"
        : (value > 0.75 ? "brightness_7" : "brightness_6")

    onMoved: () => {
        Qt.callLater(() => {
            if (value < 0.025)
                value = 0.025;

            const percent = Math.round(value * 100);

            applyProc.command = [
                "sh",
                "-c",
                `ddcutil setvcp 10 ${percent}`
            ];

            applyProc.running = true;
        });
    }
}
