on run argv
    if (count of argv) is 0 then
        error "No password argument provided"
    end if

    set passwordValue to item 1 of argv

    -- Copy password to clipboard
    do shell script "printf %s " & quoted form of passwordValue & " | pbcopy"

    -- Open Raycast import settings UI
    do shell script "open 'raycast://extensions/raycast/raycast/import-settings-data'"

    -- Terminal instructions + wait
    do shell script "
echo ''
echo 'Raycast import opened.'
echo ''
echo 'The password is already in your clipboard.'
echo ''
echo 'Please do the following in Raycast:'
echo '  1. Select the .rayconfig file from iCloud Drive'
echo '  2. Paste the password when prompted (Cmd+V)'
echo '  3. Confirm the import'
echo ''
read -p 'Press ENTER once the import is finished...'
"
end run

