#Requires AutoHotkey v2.0

;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;

;; global constants
DEBUG_MODE := 0

;; global variables
; turns to be 1 when ctrl-x is pressed
gIsCtrlXPressed := 0
; turns to be 1 when ctrl-space is pressed
gIsMarkDown := 0
; turns to be 1 when escape key is pressed
gIsEscapePressed := 0
; turns to be 1 when Ctrl-s, Ctrl-r
gIsSearching := 0

reset_pre_keys()
{
  global
  gIsCtrlXPressed := 0
  gIsMarkDown := 0
  gIsEscapePressed := 0
  Return
}

reset_all_status()
{
  reset_pre_keys()
  global gIsSearching := 0
}

delete_char()
{
  Send "{Del}"
  reset_all_status()
  Return
}

delete_backward_char()
{
  Send "{BS}"
  reset_all_status()
  Return
}

delete_backward_word()
{
  Send "^{BS}"
  reset_all_status()
  Return
}

kill_line()
{
  Send "{ShiftDown}{END}{ShiftUp}"
  Sleep 50 ;[ms] this value depends on your environment
  A_Clipboard := "" ; set empty
  Send "^x"
  ClipWait(0.1) ; wait for copy finish
  text := A_Clipboard ; get the copied text

  ;; if start pos is at line end (text is empty)
  if (text = "") {
    Send "{ShiftDown}{Right}{ShiftUp}"
    Sleep 50 ;[ms] this value depends on your environment
    Send "^x"
  }

  reset_all_status()
  Return
}

quit()
{
  Send "{ESC}"
  reset_all_status()
  Return
}

newline()
{
  Send "{Enter}"
  reset_all_status()
  Return
}

newline_and_indent()
{
  Send "{Enter}{Tab}"
  reset_all_status()
  Return
}

isearch_forward()
{
  global
  If gIsSearching
    Send "{F3}"
  Else
  {
    Send "^f"
    gIsSearching := 1
  }
  reset_pre_keys()
  Return
}

isearch_backward()
{
  global
  If gIsSearching
    Send "+{F3}"
  Else
  {
    Send "^f"
    gIsSearching := 1
  }
  reset_pre_keys()
  Return
}

kill_region()
{
  Send "^x"
  reset_all_status()
  Return
}

kill_ring_save()
{
  Send "^c"
  reset_all_status()
  Return
}

yank()
{
  Send "^v"
  reset_all_status()
  Return
}

undo()
{
  Send "^z"
  reset_all_status()
  Return
}

find_file()
{
  Send "^o"
  reset_all_status()
  Return
}

save_buffer()
{
  Send "^s"
  reset_all_status()
  Return
}

kill_window()
{
  Send "!{F4}"
  reset_all_status()
  Return
}

kill_buffer()
{
  Send "^w"
  reset_all_status()
  Return
}
move_beginning_of_line()
{
  global
  If gIsMarkDown
    Send "+{HOME}"
  Else
  {
    Send "{HOME}"
    reset_all_status()
  }
  Return
}
move_end_of_line()
{
  global
  If gIsMarkDown
    Send "+{END}"
  Else
  {
    Send "{END}"
    reset_all_status()
  }
  Return
}
previous_line()
{
  global
  If gIsMarkDown
    Send "+{Up}"
  Else
  {
    Send "{Up}"
    reset_all_status()
  }
  Return
}
next_line()
{
  global
  If gIsMarkDown
    Send "+{Down}"
  Else
  {
    Send "{Down}"
    reset_all_status()
  }
  Return
}
forward_char()
{
  global
  If gIsMarkDown
    Send "+{Right}"
  Else
  {
    Send "{Right}"
    reset_all_status()
  }
  Return
}
backward_char()
{
  global
  If gIsMarkDown
    Send "+{Left}"
  Else
  {
    Send "{Left}"
    reset_all_status()
  }
  Return
}
scroll_up()
{
  global
  If gIsMarkDown
    Send "+{PgUp}"
  Else
  {
    Send "{PgUp}"
    reset_all_status()
  }
  Return
}
scroll_down()
{
  global
  If gIsMarkDown
    Send "+{PgDn}"
  Else
  {
    Send "{PgDn}"
    reset_all_status()
  }
  Return
}
^;:: ime_switch()

; https://qiita.com/c-nuts/items/20d02e572b6a06d5dce7
ime_switch()
{
  global
  Send "{vkF3sc029}"
  reset_all_status()
  Return
}
pageup_top()
{
  global
  If gIsMarkDown
    Send "+^{Home}"
  Else
  {
    Send "^{Home}"
    reset_all_status()
  }
  Return
}

pagedown_bottom()
{
  global
  If gIsMarkDown
    Send "+^{End}"
  Else
  {
    Send "^{End}"
    reset_all_status()
  }
  Return
}

set_ignore_targets() {
  ; Applications you want to disable emacs-like keybindings
  ; (Please comment out applications you don't use)

  ; GroupAdd "IgnoreTargets", "ahk_exe TouchDesigner.exe" ; TouchDesigner
  ; GroupAdd "IgnoreTargets", "ahk_exe devenv.exe" ; Visual Studio 2022
  GroupAdd "IgnoreTargets", "ahk_exe Code.exe" ; VSCode
  GroupAdd "IgnoreTargets", "ahk_exe Code - Insiders.exe" ; VSCode Isiders  
  GroupAdd "IgnoreTargets", "ahk_exe gvim.exe" ; gvim
  GroupAdd "IgnoreTargets", "ahk_exe vim.exe" ; vim
  GroupAdd "IgnoreTargets", "ahk_exe emacs.exe" ; gvim
  GroupAdd "IgnoreTargets", "ahk_exe mintty.exe" ; mintty.exe
  GroupAdd "IgnoreTargets", "ahk_exe xshell.exe" ; tmux.exe
}

main() {
  if (DEBUG_MODE > 0)
    InstallKeybdHook

  ;; Disable log
  ListLines 0

  ;; Disable delay
  SetControlDelay 0
  ;; SetKeyDelay 0
  SetKeyDelay -1 ;; disable key delay
  SetWinDelay 0
  SendMode "Input"
  ;;SendMode "Play"

  set_ignore_targets()
}

main()

#UseHook

;; Set suspend toggle key
#SuspendExempt
^F1:: Suspend
#SuspendExempt False

#HotIf not WinActive("ahk_group IgnoreTargets")

^x:: global gIsCtrlXPressed := 1
Esc::
{
  global
  If gIsEscapePressed
  {
    Send "{Esc}"
    gIsEscapePressed := 0
  }
  Else
    gIsEscapePressed := 1
  Return
}

^f::
{
  global
  If gIsCtrlXPressed
    find_file()
  Else
    forward_char()
  Return
}
^c::
{
  global
  If gIsCtrlXPressed
    kill_window()
  Return
}
^d:: delete_char()
^h:: delete_backward_char()
^w:: delete_backward_word()
^k:: kill_line()

k::
{
  global
  If gIsCtrlXPressed
    kill_buffer()
  Else
    Send A_ThisHotkey
  Return
}

^g:: quit()
; ^j::newline_and_indent()
^m:: newline()
^s::
{
  global
  If gIsCtrlXPressed
    save_buffer()
  Else
    isearch_forward()
  Return
}
^r:: isearch_backward()
w::
{
  global
  If gIsEscapePressed
    kill_ring_save()
  Else
    Send A_ThisHotkey
  Return
}

^a:: move_beginning_of_line()
^e:: move_end_of_line()
^p:: previous_line()
^n:: next_line()
^b:: backward_char()

^v:: scroll_down()
!v:: scroll_up()
v::
{
  global
  If gIsEscapePressed
    scroll_up()
  Else
    Send A_ThisHotkey
  Return
}
!<:: pageup_top()
<::
{
  global
  If gIsEscapePressed
    pageup_top()
  Else
    Send A_ThisHotkey
  Return
}
!>:: pagedown_bottom()
>::
{
  global
  If gIsEscapePressed
    pagedown_bottom()
  Else
    Send A_ThisHotkey
  Return
}

delete_current_line_to_start() {
  Send "+{Home}"
  Send "^+{Left}"
  Send "{Delete}"
}

#w:: kill_buffer()
#c:: kill_ring_save()
#v:: yank()
; #f::^f
^u:: delete_current_line_to_start()
^/:: undo()

