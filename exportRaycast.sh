#!/bin/sh
set -e

echo
echo "Opening Raycast export settings…"
open "raycast://extensions/raycast/raycast/export-settings-data"

echo
echo "Please do the following in Raycast:"
echo "  1. Open iCloud Drive"
echo "  2. Save the .rayconfig file"
echo
read -r -p "Press ENTER once the export is finished… " </dev/tty

