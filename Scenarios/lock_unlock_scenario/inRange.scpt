-- quit the screensaver (which unlocks the screen)
--

tell application "System Events" to set the saveractivated to (exists process "ScreenSaverEngine")

if saveractivated then
  tell application "System Events"
    set pw to (do shell script "security find-generic-password -l \"BlueToothUnlock\" -w")
    tell application "ScreenSaverEngine" to quit
    delay 0.2
    keystroke pw
    keystroke return
  end tell
end if
