STATE_FILE="/tmp/wf-record-state"

start_recording() {
  # Prevent double start
  if [[ -f "$STATE_FILE" ]]; then
    echo "Already recording"
    exit 1
  fi

  # Create virtual sink
  NULL_SINK_ID=$(pactl load-module module-null-sink sink_name=Combined)

  # Get default sink safely
  DEFAULT_SINK=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')

  if [[ -z "${DEFAULT_SINK:-}" ]]; then
    echo "Could not determine default sink"
    exit 1
  fi

  # Start EasyEffects preset (background)
  easyeffects --load-preset "mic_boosted_and_rmnoise" &
  EE_PID=$!

  # Give EasyEffects time to create its source
  sleep 1

  # Find EasyEffects source dynamically
  EE_SOURCE=$(pactl list short sources | awk '/easyeffects/ {print $2; exit}')

  if [[ -z "${EE_SOURCE:-}" ]]; then
    echo "Could not find easyeffects source"
    kill -15 "$EE_PID" 2>/dev/null || true
    exit 1
  fi

  # Loopback mic (via EasyEffects) → Combined
  LOOPBACK1_ID=$(pactl load-module module-loopback \
    sink=Combined \
    source="$EE_SOURCE")

  # Loopback system audio → Combined
  LOOPBACK2_ID=$(pactl load-module module-loopback \
    sink=Combined \
    source="${DEFAULT_SINK}.monitor")

  # Ensure output directory
  mkdir -p "$HOME/Videos"

  # Start recording
  OUTPUT_FILE="$HOME/Videos/recording_$(date +%d_%m_%Y_%H_%M_%S).mkv"

  wf-recorder \
    --audio="Combined.monitor" \
    --file="$OUTPUT_FILE" &
  REC_PID=$!

  # Save state
  cat > "$STATE_FILE" <<EOF
REC_PID=$REC_PID
EE_PID=$EE_PID
NULL_SINK_ID=$NULL_SINK_ID
LOOPBACK1_ID=$LOOPBACK1_ID
LOOPBACK2_ID=$LOOPBACK2_ID
EOF

  notify-send -t 500 -h string:bgcolor:#a3be8c "Recording started"
}

end_recording() {
  if [[ ! -f "$STATE_FILE" ]]; then
    echo "No active recording"
    exit 1
  fi

  # Load state
  # shellcheck disable=SC1090
  source "$STATE_FILE"

  # Stop recorder
  kill -15 "${REC_PID:-}" 2>/dev/null || true

  # Stop EasyEffects
  kill -15 "${EE_PID:-}" 2>/dev/null || true

  # Unload modules safely
  pactl unload-module "${LOOPBACK1_ID:-}" 2>/dev/null || true
  pactl unload-module "${LOOPBACK2_ID:-}" 2>/dev/null || true
  pactl unload-module "${NULL_SINK_ID:-}" 2>/dev/null || true

  rm -f "$STATE_FILE"

  notify-send -t 500 -h string:bgcolor:#bf616a "Recording ended"
}

# Toggle logic (safe)
if [[ -f "$STATE_FILE" ]]; then
  end_recording
else
  start_recording
fi
