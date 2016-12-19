# emacs-everywhere
AutoHotkey script to provide basic Emacs key bindings for various Windows apps

To use:

1. Clone/download all the files to a folder.
2. Download and install [AutoHotkey](https://www.autohotkey.com/)
3. Double-click EmacsEverwhere.ahk to launch.
4. Ctrl+Alt+Enter toggles whether Emacs mode is active.

```
C-p	Previous line (move up)
C-n	Next line (move down)
C-f	Forward one character (move right) Note: conflicts with normal "find" shortcut
C-b	Back one character (move left) Note: conflicts with normal "bold" shortcut
M-f	Forward one word
M-b	Back one word
C-a	Start of line Note: conflicts with normal "Select all" shortcut
C-e	End of line
C-<	Start of page
C->	End of page
C-_	Undo
C-/ Undo
C-d	Delete character after cursor
M-d	Delete word after cursor
C-Backspace	Delete word before cursor
C-k	Kill line
C-w	Cut region
M-w	Copy region
C-y	Paste (no kill ring, so don’t get full Emacs yank ability)
C-Space Set mark
C-g Clear mark
M-< Goto home
M-> Goto end
C-o Open line above cursor
C-w Delete selection
C-S-f Send Ctrl-f (e.g., to trigger a 'Find' dialog)
```

More extensive key bindings are available for certain programs, such as Visual Studio and the Outlook email editor.
