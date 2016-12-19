###Enable transpose-chars and exchange-point-and-mark in the Outlook email editor

In Outlook user-defined macros can be added to the Quick Access Toolbar on
the left side of the title bar, and these are consecutively bound (by Outlook)
to Alt+1, Alt+2, Alt+3, etc. Some of the bindings for Outlook map to these
Alt+<number> sequences to invoke a macro.

The commands that use macros in this way are:
  Ctrl+T - Transpose previous 2 characters
  Ctrl+X Ctrl+X - Exchange point and mark

To configure these 2 macro-based commands, you need to do the following:

1. In Outlook, open "File>Options>Customize Ribbon" and enable the Developer tab.
2. In Outlook, click "Macro Security" on the Developer tab and "Enable all macros".
3. In Outlook, click "Visual Basic" on the Developer tab and enter the following code in the "ThisOutlookSession" project:
    ```
     Sub ExchangePointAndMark()
         Set oDoc = ActiveInspector.WordEditor
         Set oWord = oDoc.Application
         Set s = oWord.Selection
     
         s.StartIsActive = Not s.StartIsActive
     End Sub
     
     Sub TransposeChars()
         Set oDoc = ActiveInspector.WordEditor
         Set oWord = oDoc.Application
         Set s = oWord.Selection
     
         s.MoveLeft Unit:=wdCharacter, Count:=1, Extend:=wdExtend
         On Error GoTo ErrExit
         s.Cut
         s.MoveLeft Unit:=wdCharacter, Count:=1
         s.Paste
         s.MoveRight Unit:=wdCharacter, Count:=1
     ErrExit:
     End Sub

    Click the Save icon on the toolbar.
    Select "Tools>References" and tick the box "Microsoft Word 16.0 Object Library".
    (Note the "Microsoft Outlook 16.0 Object Library" is already selected, but we also need the Word one.)
    ```
4. In Outlook, select "File>New>Mail Message" to open a blank email
   composition window. In this window, locate the "Quick Access Toolbar"
   towards the left of the title bar and click the down arrow. Select "More
   Commands" and then in the "Choose commands from" dropdown select
   "Macros". Select each of the new macros in the left pane and click the
   "Add" button to add the macros to the quick launch toolbar.

5. Return to the New Message window and tap and release the Alt key to
   determine what key sequence (Alt+<number>) is bound to each of the macros
   that were added to the Quick Launch Toolbar.

6. Update this script if necessary to send the appropriate macro binding in
   response to the corresponding Emacs key sequence.
   
