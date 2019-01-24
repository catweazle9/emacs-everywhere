; Emacs key bindings for various Windows applications -- by John Cooper.
;
; Requires AutoHotkey: http://www.autohotkey.com
;
; This script provides basic Emacs key bindings for various Windows applications.
; A common set of standard bindings is specified for all apps in a group named
; EmacsApps. Some of these common bindings are overridden by specific apps, by
; virtue of being defined in a `#IfWinActive' section earlier in the file.
;
; The common set of bindings is based on an earlier script by Dave Squared:
; http://www.davesquared.net/2008/02/emacs-key-bindings-everywhere.html
;
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#UseHook ; Ensures that hotkeys are not triggered again when using the Send command.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, RegEx ; Match anywhere in a window's title and allow regex matches
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

enabledIcon := "emacs_everywhere_16.ico"
disabledIcon := "emacs_everywhere_disabled_16.ico"
IsInEmacsMode := false
NumericPrefix = 1
CtrlXPrefix = 0
MozillaClass := "MozillaWindowClass1"
OutlookClass := "OutlookGrid2"

SetEmacsMode(true)

; PowerShell ISE has different titlebar text when invoked via taskbar vs running powershell_ise.exe
GroupAdd, PoSH, Windows PowerShell ISE
GroupAdd, PoSH, powershell_ise.exe

; The following apps use all the common bindings (defined at the end). Overrides for specific
; apps can be written in earlier `#IfWinActive' sections in the file.
GroupAdd, EmacsApps, Message ahk_class rctrl_renwnd32 ; Outlook
GroupAdd, EmacsApps, ahk_class Notepad
GroupAdd, EmacsApps, Submit Changelist ahk_class Qt5QWindowIcon  ; p4v submit window
GroupAdd, EmacsApps, Pending Changelist ahk_class Qt5QWindowIcon ; p4v pending window
GroupAdd, EmacsApps, P4V ahk_class Qt5QWindowIcon,,,Perforce ; p4v new changelist window
GroupAdd, EmacsApps, Request New Swarm ahk_class Qt5QWindowIcon,,,Perforce ; p4v new changelist window
GroupAdd, EmacsApps, ahk_class TfcDlgCopyMove ; FreeCommander copy dialog
GroupAdd, EmacsApps, ahk_class TfcSearchForm ; FreeCommander XE search dialog
GroupAdd, EmacsApps, ahk_class WordPadClass
GroupAdd, EmacsApps, ahk_class ConsoleWindowClass ; cmd and powershell
GroupAdd, EmacsApps, ahk_class IMWindowClass ; Office Communicator
GroupAdd, EmacsApps, ahk_class LyncConversationWindowClass ; Office Communicator
GroupAdd, EmacsApps, ahk_class Transparent Windows Client
GroupAdd, EmacsApps, ahk_group PoSH
GroupAdd, EmacsApps, ahk_class IEFrame
GroupAdd, EmacsApps, ahk_class Chrome_WidgetWin_1
GroupAdd, EmacsApps, ahk_class Wox
GroupAdd, EmacsApps, - Microsoft Visual Studio
GroupAdd, EmacsApps, JetPopupMenuView ; ReSharper popups
GroupAdd, EmacsApps, Rename ; ReSharper Rename dialog
GroupAdd, EmacsApps, ahk_class HwndWrapper.*,Find Results,,Sudoku UI ; Resharper Find Usages dialog (this is why TitleMatchMode RegEx is used)
GroupAdd, EmacsApps, - PowerPoint

SetEmacsMode(toActive) {
  local iconFile := toActive ? enabledIcon : disabledIcon
  local state := toActive ? "ON" : "OFF"

  IsInEmacsMode := toActive
;  TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%  
;  Sleep, 1500
;  TrayTip
}

SendCommand(k1, k2="", k3="", k4="", k5="", k6="") {
  global IsInEmacsMode
  global NumericPrefix
  global CtrlXPrefix
  global VSMark
  if (VSMark = 1)
  {
    ; If the key binding contains a numeric arg and VSMark is set, prepend Shift to extend the selection
    if k1 contains %A_Space%1,%A_Space%4
    {
      ; MsgBox digit %k1%
      k1 := "+" . k1
    }
  }

  if (IsInEmacsMode) {
    Send, %k1%
    if (k2<>"") {
      Send, %k2%
    }
    if (k3<>"") {
      Send, %k3%
    }
    if (k4<>"") {
      Send, %k4%
    }
    if (k5<>"") {
      Send, %k5%
    }
    if (k6<>"") {
      Send, %k6%
    }
  } else {
  ; Pass through the original keystroke.
  ; This requires parsing A_ThisHotkey to determine the modifiers to specify for the Send command.
  ; Originally just had: Send, %A_ThisHotkey%
  ; .. but this caused the string "Delete" to be sent when pressing the Delete key.
  ;
  ; Code taken from https://autohotkey.com/boards/viewtopic.php?f=5&t=25643
  ; Alternative approach: Laszlo's reply at https://autohotkey.com/board/topic/9223-the-shortest-way-to-send-a-thishotkey/
    FoundPos := RegExMatch(A_ThisHotkey, "O)([\^!#+]+)(.*)", m)
    if (FoundPos = 0) 
    {
      Modifiers =
      Key = %A_ThisHotkey%
    } else {
      Modifiers := m[1]
      Key := m[2]

    }
    ; MsgBox, % Modifiers "`n" Key
    Send, % Modifiers "{" Key "}"
  }
  NumericPrefix = 1
  CtrlXPrefix = 0
  return
}

SendConditionally(k1, class)
{
  global IsInEmacsMode
  global NumericPrefix
  global CtrlXPrefix

  ControlGetFocus, f, A
  if (IsInEmacsMode && f = class)
    Send %k1%
  else
    Send, %A_ThisHotkey% ; Pass through original keystroke

  NumericPrefix = 1
  CtrlXPrefix = 0
  return
}

SendCtrlXConditional(k1, k2)
{
  global CtrlXPrefix

  if CtrlXPrefix = 1
    SendCommand(k1)
  else
    SendCommand(k2)
  return
}

IncreaseNumericPrefix()
{
  global IsInEmacsMode
  global NumericPrefix
  global CtrlXPrefix

  if (IsInEmacsMode) 
  {
    NumericPrefix *= 4
    if NumericPrefix > 256
      NumericPrefix = 1
    CtrlXPrefix = 0
  }
  return
}

SetMark()
{
  global VSMark
  VSMark = 1
}

ClearMark()
{
  global VSMark
  VSMark = 0
}

^!Enter::SetEmacsMode(!IsInEmacsMode)

#IfWinActive foobar2000
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")
^v::SendCommand("{PgDn}")
!v::SendCommand("{PgUp}")
!<::SendCommand("{Home}")
!>::SendCommand("{End}")
^u::IncreaseNumericPrefix()
#IfWinActive

#IfWinActive ahk_class WMPlayerApp
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")
^v::SendCommand("{PgDn}")
!v::SendCommand("{PgUp}")
!b::SendCommand("!{Left}")
!<::SendCommand("{Home}")
!>::SendCommand("{End}")
^u::IncreaseNumericPrefix()
#IfWinActive

#IfWinActive - Outlook ahk_class rctrl_renwnd32
; The following are for the inline editing capability in Outlook
^f::SendConditionally("{Right " . NumericPrefix . "}", "_WwG2")
^b::SendConditionally("{Left " . NumericPrefix . "}", "_WwG2")

!f::SendConditionally("^{Right " . NumericPrefix . "}", "_WwG2")
!b::SendConditionally("^{Left " . NumericPrefix . "}", "_WwG2")

^n::SendConditionally("{Down " . NumericPrefix . "}", "_WwG2")
^p::SendConditionally("{Up " . NumericPrefix . "}", "_WwG2")
^a::SendConditionally("{Home 1}", "_WwG2")
^e::SendConditionally("{End 1}", "_WwG2")

!<::SendConditionally("^{Home 1}", "_WwG2")
!>::SendConditionally("^{End 1}", "_WwG2")

^d::SendConditionally("{Delete " . NumericPrefix . "}", "_WwG2")
!d::SendConditionally("^+{Right}{Delete}", "_WwG2")
!Delete::SendConditionally("^+{Left}{Del}", "_WwG2")
^Backspace::SendConditionally("^+{Left}{Del}", "_WwG2")
^k::SendConditionally("+{End}{Delete}", "_WwG2")

^w::SendCommand("^{x}")

^Space::SendConditionally("{F8}", "_WwG2")

^g::
  ClearMark()
  SendConditionally("{ESC}", "_WwG2")
  return

^u::IncreaseNumericPrefix()
^/::SendConditionally("^z", "_WwG2")

#IfWinActive

; Overrides for the Microsoft Outlook email editor
#IfWinActive - Message ahk_class rctrl_renwnd32

; Ctrl+K - Delete to end of line
^k::
  ControlGetFocus, OutputVar, A
  if ErrorLevel
    MsgBox, The target window doesn't exist or none of its controls has input focus.
  else
    if (OutputVar = "RichEdit20WPT2" or OutputVar = "RichEdit20WPT3")
        SendCommand("^k")
    else 
      SendCommand("+{End}", "+{Left}", "^{c}", "{Delete}")
    ;MsgBox, Control with focus = %OutputVar%
  return

^!k::SendCommand("^k")

; Ctrl+R - Search backwards
^r::SendCommand("^f", "+!;", "u", "{Return}", "!{n}", "{Return}")

; Ctrl+S - Search forwards
; Ctrl+X Ctrl+S - Save
^s::
  if CtrlXPrefix = 1
    SendCommand("^s")
  else
    SendCommand("^f", "+!;", "d", "{Return}", "!{n}", "{Return}")
  return

; Ctrl+T - Transpose previous characters
^t::
  ControlGetFocus, OutputVar, A
  if ErrorLevel
    MsgBox, The target window doesn't exist or none of its controls has input focus.
  else
    if (OutputVar = "_WwG1")
      SendCommand("!7")
  return

; Ctrl+V - Page down
^v::SendCommand("{PgDn}")

; Ctrl+W - Cut
^w::SendCommand("^{x}")

; Ctrl+X - Prefix
^x::
  if CtrlXPrefix = 1
    SendCommand("!6")
  else
    CtrlXPrefix = 1
  return

; Ctrl+Y - Paste
^y::SendCommand("^{v}")

; Ctrl+Shift+Y - Paste plain text
^+y::SendCommand("^+{v}")

; Ctrl+<space> - Set mark
^Space::SendCommand("{F8}")

; Ctrl+Shift+Z - Redo
^+z::SendCommand("^{y}")

; Ctrl+Alt+B - Bold
^!b::SendCommand("^{b}")

; Ctrl+Alt+I - Italic
^!i::SendCommand("^{i}")

; Ctrl+Alt+U - Underline
^!u::SendCommand("^{u}")

; Alt+D - Delete word forward
!d::SendCommand("^{Delete " . NumericPrefix . "}")

; Alt+V - Page up
!v::SendCommand("{PgUp}")
#IfWinActive ; End of Outlook bindings

; Word's find and replace dialog
#IfWinActive Find and Replace
^g::SendCommand("{Escape}")
^r::SendCommand("+!;", "u", "{Return}", "!{n}", "!f")
^s::SendCommand("+!;", "d", "{Return}", "!{n}", "!f")
#IfWinActive ; End of Word's find and replace dialog bindings

; Microsoft Word's save changes confirmation dialog
#IfWinActive ahk_class #32770
^g:: SendCommand("{Escape}")
#IfWinActive ; End of Word's save changes dialog bindings

; Firefox bindings for the address/search bar
#IfWinActive ahk_class MozillaWindowClass
;^a::SendConditionally("{Home}", MozillaClass)
;^e::SendConditionally("{End}", MozillaClass)
;^f::SendConditionally("{Right}", MozillaClass)
;^b::SendConditionally("{Left}", MozillaClass)
;!f::SendConditionally("^{Right}", MozillaClass)
;!b::SendConditionally("^{Left}", MozillaClass)
;!d::SendConditionally("^+{Right}{Delete}", MozillaClass)
;^d::SendConditionally("{Delete}", MozillaClass)
;^k::SendCommand("+{End}","{Delete}")
^a::SendCommand("{Home}")
^e::SendCommand("{End}")
^f::SendCommand("{Right " . NumericPrefix . "}")
^b::SendCommand("{Left " . NumericPrefix . "}")
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")
^u::IncreaseNumericPrefix()
^+n::SendCommand("^n")
^+p::SendCommand("^p")
!f::SendCommand("^{Right " . NumericPrefix . "}")
!b::SendCommand("^{Left " . NumericPrefix . "}")
!d::SendCommand("^+{Right}{Delete}")
^d::SendCommand("{Delete}")
^k::SendCommand("+{End}","{Delete}")
^!d::SendCommand("^l")
;^+f::SendCommand("^+e")
^+f::SendCommand("^f")
^+d::SendCommand("^d")
^!b::SendCommand("!b")
!a::SendCommand("!b")
F3::SendCommand("^f")
#IfWinActive ; End of Firefox bindings

; IE
#IfWinActive ahk_class IEFrame
^!d::SendCommand("^l")
!d::SendCommand("!d")
^w::SendCommand("^w")
#IfWinActive ; End of IE bindings

; FreeCommander
#IfWinActive ahk_class FreeCommanderXE.SingleInst.1
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")
^u::IncreaseNumericPrefix()
^g::SendCommand("{Escape}")
^/::SendCommand("^{Home}")
^+d::SendCommand("^+v")
!b::SendCommand("!{Left}")
!f::SendCommand("!{Right}")
!<::SendCommand("{Home}")
!>::SendCommand("{End}")
#IfWinActive ; End of FreeCommander bindings

#IfWinActive ahk_class TfcSearchForm
Space::SendCommand("+{Space}")
#IfWinActive

; Cmd and PowerShell
#IfWinActive, ahk_class ConsoleWindowClass
^u::SendCommand("^{Home}")
^k::SendCommand("^{End}")
^l::SendCommand("{ESC}cls{ENTER}")
^y::SendInput ! ep
#IfWinActive ; End of cmd and powershell bindings

; PowerShell ISE
#IfWinActive, ahk_group PoSH
;^u::SendCommand("^+{Home}","{Del}")
^+d::SendCommand("^d")
^+s::SendCommand("^i")
#IfWinActive ; End of cmd and PowerShell ISE bindings

; Visual Studio
#IfWinActive, - Microsoft Visual Studio
^n::SendCtrlXConditional("^x^n", "{Down " . NumericPrefix . "}")
^p::SendCtrlXConditional("^x^p", "{Up " . NumericPrefix . "}")
^b::SendCtrlXConditional("^x^b", "{Left " . NumericPrefix . "}")
^d::SendCommand("{Delete " . NumericPrefix . "}")
^v::SendCommand("{PgDn 1}")
!v::SendCommand("{PgUp 1}")
^i::SendCtrlXConditional("^{Space}", "^i")
^s::SendCtrlXConditional("^s", "^i")
^r::SendCommand("^+i")
^y::SendCommand("^v")
^g::
  ClearMark()
  SendCommand("{ESC}")
  return
!w::
  SendCommand("^c")
  ClearMark()
  SendCommand("{ESC}")
  return
!x::SendCommand("^wa")
^x::
  if CtrlXPrefix = 1
    SendCommand("^x^x")
  else
    CtrlXPrefix = 1
  return
b::SendCtrlXConditional("+!u", "b")
d::SendCtrlXConditional("^xd", "d")
;h::SendCtrlXConditional("^{PgUp}", "h")
;h::SendCtrlXConditional("^xf", "h")
k::SendCtrlXConditional("^xk", "k")
;l::SendCtrlXConditional("^{PgDn}", "l")
m::SendCtrlXConditional("^xm", "m")
r::SendCtrlXConditional("^xr", "r")
u::SendCtrlXConditional("^ku", "u")
c::SendCtrlXConditional("^kc", "c")
^!a::SendCommand("!{Up}")
^!e::SendCommand("!{Down}")
^!h::
  SetMark()
  SendCommand("^+[")
  return
^!j::SendCommand("^e^u")
^F7::SendCommand("+{F12}")
^k::SendCommand("^x^k")
^+\::SendCommand("^e\")
^+f::SendCommand("^+f")
^_::SendCommand("^+_")
#IfWinActive ; End of Visual Studio bindings

; p4v - for the 'pending' window, ctrl+d performs a diff when focus is on the shelved files pane
#IfWinActive, Pending Changelist ahk_class Qt5QWindowIcon
^d::
; Send both Ctrl+d (orig keystroke) and Delete.
; In the Description pane, Delete deletes char forward and Ctrl+d is ignored
; In the Shelved Files pane, Delete is ignored and Ctrl+d triggers a diff
  Send, %A_ThisHotkey% ; Pass through original keystroke
  SendCommand("{Delete " . NumericPrefix . "}")
  return
#IfWinActive

; MusicBee
#IfWinActive MusicBee ahk_class WindowsForms10.Window.8.app.0.34f5582_r10_ad1
^Space::SetMark()
^g::
  ClearMark()
  SendCommand("{ESC}")
  return
^u::IncreaseNumericPrefix()

^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")

^v::SendCommand("{PgDn}")
!v::SendCommand("{PgUp}")
!<::SendCommand("{Home 1}")
!>::SendCommand("{End 1}")
#IfWinActive ; End MusicBee bindings

; PyCharm
#IfWinActive, PyCharm ahk_class SunAwtFrame
^u::IncreaseNumericPrefix()

; Character navigation
;^f::SendCommand("{Right " . NumericPrefix . "}")
;^b::SendCommand("{Left " . NumericPrefix . "}")

; Word Navigation
!f::SendCommand("^{Right " . NumericPrefix . "}")
!b::SendCommand("^{Left " . NumericPrefix . "}")

; Line Navigation
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")
#IfWinActive ; End PyCharm bindings

; Common bindings that apply to all apps in the EmacsApps group
#IfWinActive, ahk_group EmacsApps
^Space::SetMark()
^g::
  ClearMark()
  SendCommand("{ESC}")
  return
^u::IncreaseNumericPrefix()

; Character navigation
^f::SendCommand("{Right " . NumericPrefix . "}")
^b::SendCommand("{Left " . NumericPrefix . "}")

; Word Navigation
!f::SendCommand("^{Right " . NumericPrefix . "}")
!b::SendCommand("^{Left " . NumericPrefix . "}")

; Line Navigation
^a::SendCommand("{Home 1}")
^e::SendCommand("{End 1}")
^n::SendCommand("{Down " . NumericPrefix . "}")
^p::SendCommand("{Up " . NumericPrefix . "}")

!n::SendCommand("^{Down}")
!p::SendCommand("^{Up}")

; Page Navigation
; Ctrl-V disabled. Too reliant on that for pasting :$
;^v::SendCommand("{PgDn}")
!<::SendCommand("^{Home 1}")
!>::SendCommand("^{End 1}")

; Undo
^_::SendCommand("^z")
^/::SendCommand("^z")

; Killing and Deleting
^d::SendCommand("{Delete " . NumericPrefix . "}")
!d::SendCommand("^+{Right}","{Delete}")
!Delete::SendCommand("^+{Left}","{Del}")
^Backspace::SendCommand("^+{Left}","{Del}")
^k::SendCommand("+{End}","{Delete}")
^o::SendCommand("{Return}","{Up}","{End}")
Backspace::
  SendCommand("{Backspace}")
  ClearMark()
  return
Delete::
  SendCommand("{Delete}")
  ClearMark()
  return
^w::
  SendCommand("+{Delete}")
  ClearMark()
  return
!w::
  SendCommand("^{Insert}","{Shift Up}") ;copy region
  ClearMark()
  return
^+f::SendCommand("^f") ; Use Ctrl+Shift+f to bring up the find window
#IfWinActive ; End of common bindings

~!F12::
  Suspend, Permit
  Suspend
  Return

~^!F12::Reload
