{ pkgs, ... }:

pkgs.writeShellScriptBin "optimizeImage" ''
  temp_img=$(mktemp)

  echo "Optimizing image: $1"
  ${pkgs.imagemagick}/bin/convert "$1" -strip -alpha on -define png:compression -level=9 "$temp_image"

  mv "$temp_image" "$1"

  echo "Replaced original image with optimized version: $1"
''
