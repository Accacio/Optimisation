#SingleInstance Force
#installKeybdHook
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2



#ifwinactive, Adobe Acrobat Reader DC
run %A_ScriptDir%\dspdfviewer.exe
~Down::
ControlSend,, {Down}, DS PDF Viewer - Secondary Window
return
~Right::
ControlSend,, {Right}, DS PDF Viewer - Secondary Window
return
~Left::
ControlSend,, {Left}, DS PDF Viewer - Secondary Window
return
~Up::
ControlSend,, {Up}, DS PDF Viewer - Secondary Window
return
#ifwinactive


#ifwinactive, apresentacao.ahk
^s::
send, {ctrl down}s{ctrl up}
sleep 200
Reload
;run Ahk2Exe.exe /in %A_ScriptDir%\apresentacao.ahk
return
#ifwinactive