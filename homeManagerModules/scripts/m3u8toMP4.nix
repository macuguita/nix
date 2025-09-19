{ pkgs, ... }:

pkgs.writeShellScriptBin "m3u8toMP4" ''
  M3U8_URL=$1
  OUTPUT_FILE="output.mp4"
  TEMP_DIR="downloads"
  FILE_LIST="filelist.txt"
  MAX_RETRIES=3
  LIMIT_RATE="10M"   # Limit download speed (e.g., 100K for 100KB/s)
  DELAY_BETWEEN=2

  mkdir -p "$TEMP_DIR"

  if [[ "$M3U8_URL" == http* ]]; then
      echo "Downloading M3U8 file..."
      ${pkgs.curl}/bin/curl -o "$TEMP_DIR/playlist.m3u8" "$M3U8_URL"
  else
      cp "$M3U8_URL" "$TEMP_DIR/playlist.m3u8"
  fi

  echo "Parsing and downloading segments..."
  COUNT=0
  > "$FILE_LIST"
  while read -r LINE; do
      if [[ "$LINE" == \#* ]]; then
          continue
      fi

      FILENAME=$(printf "%05d.ts" $COUNT)
      SUCCESS=0
      ATTEMPT=1

      while [[ $SUCCESS -eq 0 && $ATTEMPT -le $MAX_RETRIES ]]; do
          echo "Downloading $LINE (Attempt $ATTEMPT)..."
          ${pkgs.curl}/bin/curl --limit-rate "$LIMIT_RATE" -s -o "$TEMP_DIR/$FILENAME" "$LINE"

          if [[ $? -eq 0 && -s "$TEMP_DIR/$FILENAME" ]]; then
              echo "Download succeeded: $LINE"
              SUCCESS=1
          else
              echo "Download failed: $LINE"
              ATTEMPT=$((ATTEMPT + 1))
          fi
      done

      if [[ $SUCCESS -eq 1 ]]; then
          echo "file '$TEMP_DIR/$FILENAME'" >> "$FILE_LIST"
      else
          echo "Skipping $LINE after $MAX_RETRIES attempts."
      fi

      COUNT=$((COUNT + 1))
      sleep "$DELAY_BETWEEN" # Add delay between downloads
  done < "$TEMP_DIR/playlist.m3u8"

  echo "Concatenating segments into $OUTPUT_FILE..."
  ${pkgs.ffmpeg}/bin/ffmpeg -f concat -safe 0 -i "$FILE_LIST" -c copy "$OUTPUT_FILE"

  echo "Cleaning up..."
  rm -rf "$TEMP_DIR" "$FILE_LIST"

  echo "Done! Output saved as $OUTPUT_FILE"
''
