on run {password}
    -- Open Raycast import settings dialog
    do shell script "open 'raycast://extensions/raycast/raycast/import-settings-data'"

    tell application "System Events"
        keystroke return
        delay 0.5

        -- Open "Go to Folder"
        keystroke "G" using {command down, shift down}
        delay 0.5

        -- Type the file path and confirm
        keystroke "~/Library/Mobile Documents/com~apple~CloudDocs"
        delay 0.5
        keystroke return
        delay 0.5

        -- Type the filename and confirm
        keystroke "raycast_backup.rayconfig"
        delay 0.5
        keystroke return
        delay 0.5

        -- Enter password and confirm
        keystroke password
        delay 0.5
        keystroke return
        delay 0.5
        keystroke return
    end tell
end run
