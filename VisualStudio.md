In Visual Studio, I have the following bindings configured to provide more of an Emacs-like experience:

```
Ctrl+L - Edit.ScrollLineCenter
Alt+G - Edit.GoTo
Alt+M - Edit.LineStartAfterIndentation
Ctrl+X,Ctrl+X - Edit.SwapAnchor
Alt+. - Edit.GoToDefinition
Ctrl+X,R - File.Perforce.P4VS.Revert
Ctrl+X,D - File.Perforce.P4VS.Diff_Against_Have_Revision
Ctrl+X,K - Window.CloseDocumentWindow
Ctrl+X,Ctrl+B - Window.Windows (Global)
Ctrl+Alt+\ - Edit.FormatSelection
Alt+Shift+7 - View.ForwardBrowseContext (for deterministically moving down the GoToDefinition stack)
Alt+Shift+8 - View.PopBrowseContext (for deterministically popping up the GoToDefinition stack)
Ctrl+Shift+\ - Edit.DeleteHorizontalWhiteSpace
```

Note that some of the above are invoked by other bindings in the EmacsEverywhere.ahk script.
