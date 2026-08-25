#!/usr/bin/env python3

import os
import signal
import subprocess
import sys
import time
from pathlib import Path


STATE_DIR = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "wf-recording"
STATE_FILE = STATE_DIR / "state"
OUTPUT_DIR = Path.home() / "Videos"


def run(*args: str, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(args, check=check, text=True, capture_output=True)


def pactl(*args: str) -> str:
    result = run("pactl", *args)
    return result.stdout.strip()


def load_module(*args: str) -> int:
    return int(pactl("load-module", *args))


def unload_module(module_id: int | None) -> None:
    if module_id is None:
        return

    subprocess.run(
        ["pactl", "unload-module", str(module_id)],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def notify(message: str, color: str):
    subprocess.run(
        [
            "notify-send",
            "-t",
            "500",
            "-h",
            f"string:bgcolor:{color}",
            message,
        ],
        check=False,
    )


def load_state() -> dict[str, int]:
    state = {}

    for line in STATE_FILE.read_text().splitlines():
        key, value = line.split("=", 1)
        state[key] = int(value)

    return state


class Recorder:
    def __init__(self):
        self.recorder: subprocess.Popen | None = None
        self.null_sink: int | None = None
        self.mic_loopback: int | None = None
        self.system_loopback: int | None = None

    def cleanup(
        self,
        recorder_pid: int | None = None,
        null_sink: int | None = None,
        mic_loopback: int | None = None,
        system_loopback: int | None = None,
    ):
        # If we're in the original process, use the Popen object.
        if self.recorder is not None and self.recorder.poll() is None:
            self.recorder.terminate()

            try:
                self.recorder.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.recorder.kill()
                self.recorder.wait()

        # If we're stopping from a new invocation, use the saved PID.
        elif recorder_pid is not None:
            try:
                os.kill(recorder_pid, signal.SIGTERM)
            except ProcessLookupError:
                pass

            # Give wf-recorder time to finalize the MKV.
            for _ in range(50):
                try:
                    os.kill(recorder_pid, 0)
                except ProcessLookupError:
                    break

                time.sleep(0.1)

        unload_module(mic_loopback)
        unload_module(system_loopback)
        unload_module(null_sink)

        STATE_FILE.unlink(missing_ok=True)

    def start(self):
        if STATE_FILE.exists():
            raise RuntimeError("Already recording")

        STATE_DIR.mkdir(parents=True, exist_ok=True)
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

        default_sink = pactl("get-default-sink")
        default_source = pactl("get-default-source")

        # Create virtual sink
        self.null_sink = load_module(
            "module-null-sink",
            "sink_name=Combined",
        )

        # Microphone → Combined
        self.mic_loopback = load_module(
            "module-loopback",
            "sink=Combined",
            f"source={default_source}",
        )

        # System audio → Combined
        self.system_loopback = load_module(
            "module-loopback",
            "sink=Combined",
            f"source={default_sink}.monitor",
        )

        output = OUTPUT_DIR / (
            f"recording_{time.strftime('%Y-%m-%d_%H-%M-%S')}.mkv"
        )

        self.recorder = subprocess.Popen([
            "wf-recorder",
            "--audio=Combined.monitor",
            f"--file={output}",
        ])

        # Save everything needed by a future invocation.
        STATE_FILE.write_text(
            f"recorder_pid={self.recorder.pid}\n"
            f"null_sink={self.null_sink}\n"
            f"mic_loopback={self.mic_loopback}\n"
            f"system_loopback={self.system_loopback}\n"
        )

        notify("Recording started", "#a3be8c")

    def stop(self):
        if not STATE_FILE.exists():
            raise RuntimeError("No active recording")

        state = load_state()

        self.cleanup(
            recorder_pid=state.get("recorder_pid"),
            null_sink=state.get("null_sink"),
            mic_loopback=state.get("mic_loopback"),
            system_loopback=state.get("system_loopback"),
        )

        notify("Recording ended", "#bf616a")


def main():
    recorder = Recorder()

    if STATE_FILE.exists():
        recorder.stop()
        return

    def handle_signal(signum, frame):
        recorder.cleanup(
            null_sink=recorder.null_sink,
            mic_loopback=recorder.mic_loopback,
            system_loopback=recorder.system_loopback,
        )
        sys.exit(128 + signum)

    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)

    try:
        recorder.start()
    except Exception:
        recorder.cleanup(
            null_sink=recorder.null_sink,
            mic_loopback=recorder.mic_loopback,
            system_loopback=recorder.system_loopback,
        )
        raise


if __name__ == "__main__":
    main()
