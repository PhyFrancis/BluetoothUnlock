-- start screensaver (which locks the screen)
-- activate application "ScreenSaverEngine"

tell application "System Events" to set the saveractivated to (exists process "ScreenSaverEngine")


if not(saveractivated) then
  tell application "System Events"
    set ss to screen saver "Random"
    start ss
  end tell
end if
