" Test moving to non-existing non-whitespace vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

26normal! 31|
normal [|
call IsPosition([26, 31], "no move from end of longest line")
normal ]|
call IsPosition([26, 31], "no move from end of longest line")

call vimtest#Quit()
