{ pkgs, ... }:

pkgs.writeShellScriptBin "optimizeImage" ''
  temp_img=$(mktemp)

  echo "Optimizing image: $1"
  ${pkgs.imagemagick}/bin/magick "$1" -strip -alpha on -define png:compression-level=9 "$temp_img"

  if [[ $? -eq 0 ]]
  then
    mv "$temp_img" "$1"
    echo "Replaced original image with optimized version: $1"
  else
    echo "ERROR: could not optimize the image"
  fi
''
