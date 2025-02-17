-- filepath: /Users/miguelraposo/.local/share/chezmoi/importRaycast.scpt
do shell script "open 'raycast://extensions/raycast/raycast/export-settings-data'"

do shell script "osascript -e 'tell application \"System Events\" to keystroke return without UI'"
delay 0.5
do shell script "osascript -e 'tell application \"System Events\" to keystroke \"G\" using {command down, shift down} without UI'"
delay 0.5
do shell script "osascript -e 'tell application \"System Events\" to keystroke \"~/Library/Mobile Documents/com~apple~CloudDocs\" without UI'"
delay 0.5
do shell script "osascript -e 'tell application \"System Events\" to keystroke return without UI'"
delay 0.5
do shell script "osascript -e 'tell application \"System Events\" to keystroke return without UI'"
delay 0.5
do shell script "osascript -e 'tell application \"System Events\" to keystroke space using {command down} without UI'"

delay 0.5 -- Wait for the file to be saved

-- Find and rename the .rayconfig file
set iCloudFolder to POSIX path of (path to home folder) & "Library/Mobile Documents/com~apple~CloudDocs/"
set rayconfigFiles to do shell script "find " & quoted form of iCloudFolder & " -name '*.rayconfig'"

if rayconfigFiles is not "" then
    set rayconfigFile to first paragraph of rayconfigFiles
    set newFilePath to iCloudFolder & "raycast_backup.rayconfig"
    do shell script "mv -f " & quoted form of rayconfigFile & " " & quoted form of newFilePath
end if