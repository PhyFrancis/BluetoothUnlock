-- start IntelliJ 

tell application "System Events" to set the intellijActicated to (exists process "idea")

if not(intellijActicated) then
  activate application "IntelliJ IDEA 14 CE"
end if

