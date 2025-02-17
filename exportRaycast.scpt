-- filepath: /Users/miguelraposo/.local/share/chezmoi/exportRaycastPreferences.scpt
tell application "System Events"
  keystroke space using {command down} -- Open raycast
end tell

delay 2 -- Wait for Raycast to open

tell application "System Events"
  keystroke "export" -- Search for export
  delay 1
  keystroke return -- Confirm export
  delay 1
  keystroke return -- Confirm again
  delay 1
  keystroke "G" using {command down, shift down} -- Open "Go to Folder" dialog
  delay 1
  keystroke "~/Library/Mobile Documents/com~apple~CloudDocs" -- Type iCloud folder path
  delay 1
  keystroke return -- Confirm path
  delay 1
  keystroke return -- Confirm save
end tell
