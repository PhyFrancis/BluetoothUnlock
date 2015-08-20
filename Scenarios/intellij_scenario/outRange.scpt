-- quit IntelliJ
--

tell application "System Events" to set the intellijActicated to (exists process "idea")

if intellijActicated then
  tell application  "IntelliJ IDEA 14 CE" to quit
end if
