{ pkgs, ... }:

pkgs.writeShellScriptBin "optimizeImage" ''
  if [[ $# -lt 1 ]]; then
    echo "ERROR: Missing input image."
    echo "Usage: optimizeImage <input-image> [output-image]"
    exit 1
  fi

  input="$1"
  output="''${2:-}"

  if [[ ! -f "$input" ]]; then
    echo "ERROR: File does not exist or is not a regular file: $input"
    exit 1
  fi

  if [[ -z "$output" ]]; then
    temp_img=$(mktemp)
    final_target="$input"
  else
    temp_img="$output"
    final_target="$output"
  fi

  echo "Optimizing image: $input"
  ${pkgs.imagemagick}/bin/magick "$input" -strip -alpha on -define png:compression-level=9 "$temp_img"

  if [[ -z "$output" ]]; then
    mv "$temp_img" "$input"
  fi

  echo "Optimized image written to: $final_target"
''

