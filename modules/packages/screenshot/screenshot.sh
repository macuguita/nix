SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
FILENAME="screenshot_$(date +%Y_%m_%d_%H_%M_%S).png"
OUTPUT="$SCREENSHOT_DIR/$FILENAME"

fullscreen() {
    grim - | tee "$OUTPUT" | wl-copy
}

areaSelection() {
    grim -g "$(slurp)" - | tee "$OUTPUT" | wl-copy
}

run_screenshot() {
    case $1 in
        fullscreen) fullscreen ;;
        area) areaSelection ;;
        *)
            dunstify -u critical "Missing or invalid argument to $0 script"
            exit 1
            ;;
    esac
}

mkdir -p "$SCREENSHOT_DIR"

if run_screenshot "$1"; then
    dunstify "Screenshot saved to $FILENAME"
else
    dunstify -u critical "Failed to save screenshot"
fi
