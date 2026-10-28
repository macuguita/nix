use std::{
    env, fs, mem,
    path::PathBuf,
    process::{Command, Stdio},
    thread,
    time::{Duration, Instant},
};

use anyhow::{bail, Context, Result};
use nix::{
    errno::Errno,
    sys::signal::{kill, Signal},
    unistd::Pid,
};
use notify_rust::{Hint, Notification, Timeout};
use serde::{Deserialize, Serialize};

fn state_dir() -> PathBuf {
    let base = env::var_os("XDG_RUNTIME_DIR").unwrap_or_else(|| "/tmp".into());
    PathBuf::from(base).join("wf-recording")
}

fn state_file() -> PathBuf {
    state_dir().join("state")
}

fn output_dir() -> PathBuf {
    PathBuf::from(env::var_os("HOME").unwrap_or_default()).join("Videos")
}

fn pactl(args: &[&str]) -> Result<String> {
    let out = Command::new("pactl")
        .args(args)
        .output()
        .context("failed to run pactl")?;
    if !out.status.success() {
        bail!(
            "pactl {args:?} failed: {}",
            String::from_utf8_lossy(&out.stderr).trim()
        );
    }
    Ok(String::from_utf8(out.stdout)?.trim().to_owned())
}

fn unload_module(id: u32) {
    let _ = Command::new("pactl")
        .args(["unload-module", &id.to_string()])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status();
}

struct Module(u32);

impl Module {
    fn load(name: &str, args: &[&str]) -> Result<Self> {
        let mut full = vec!["load-module", name];
        full.extend_from_slice(args);
        Ok(Self(pactl(&full)?.parse()?))
    }

    fn id(&self) -> u32 {
        self.0
    }

    fn keep(self) {
        mem::forget(self);
    }
}

impl Drop for Module {
    fn drop(&mut self) {
        unload_module(self.0);
    }
}

fn notify(message: &str, color: &str) {
    let _ = Notification::new()
        .summary(message)
        .timeout(Timeout::Milliseconds(500))
        .hint(Hint::Custom("bgcolor".into(), color.into()))
        .show();
}

#[derive(Serialize, Deserialize)]
struct State {
    recorder_pid: u32,
    null_sink: u32,
    mic_loopback: u32,
    system_loopback: u32,
}

impl State {
    fn save(&self) -> Result<()> {
        fs::write(state_file(), serde_json::to_vec(self)?)?;
        Ok(())
    }

    fn load() -> Result<Self> {
        let text = fs::read(state_file()).context("failed to read state file")?;
        Ok(serde_json::from_slice(&text).context("corrupt state file")?)
    }
}

fn start() -> Result<()> {
    fs::create_dir_all(state_dir())?;
    fs::create_dir_all(output_dir())?;

    let default_sink = pactl(&["get-default-sink"])?;
    let default_source = pactl(&["get-default-source"])?;

    let null_sink = Module::load("module-null-sink", &["sink_name=Combined"])?;
    let mic = Module::load(
        "module-loopback",
        &["sink=Combined", &format!("source={default_source}")],
    )?;
    let system = Module::load(
        "module-loopback",
        &["sink=Combined", &format!("source={default_sink}.monitor")],
    )?;

    let output = output_dir().join(format!(
        "recording_{}.mkv",
        chrono::Local::now().format("%Y-%m-%d_%H-%M-%S")
    ));

    let mut child = Command::new("wf-recorder")
        .arg("--audio=Combined.monitor")
        .arg(format!("--file={}", output.display()))
        .spawn()
        .context("failed to start wf-recorder")?;

    let state = State {
        recorder_pid: child.id(),
        null_sink: null_sink.id(),
        mic_loopback: mic.id(),
        system_loopback: system.id(),
    };

    if let Err(e) = state.save() {
        let _ = child.kill();
        let _ = child.wait();
        return Err(e);
    }

    null_sink.keep();
    mic.keep();
    system.keep();

    notify("Recording started", "#a3be8c");
    Ok(())
}

fn stop() -> Result<()> {
    let state = State::load()?;
    let pid = Pid::from_raw(state.recorder_pid as i32);

    match kill(pid, Signal::SIGTERM) {
        Ok(()) | Err(Errno::ESRCH) => {}
        Err(e) => return Err(e.into()),
    }

    let deadline = Instant::now() + Duration::from_secs(5);
    while Instant::now() < deadline && kill(pid, None).is_ok() {
        thread::sleep(Duration::from_millis(100));
    }

    unload_module(state.mic_loopback);
    unload_module(state.system_loopback);
    unload_module(state.null_sink);

    let _ = fs::remove_file(state_file());

    notify("Recording ended", "#bf616a");
    Ok(())
}

fn main() -> Result<()> {
    if state_file().exists() {
        stop()
    } else {
        start()
    }
}
