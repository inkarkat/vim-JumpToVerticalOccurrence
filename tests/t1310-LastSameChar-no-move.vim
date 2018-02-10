" Test moving to non-existing last same character under cursor vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

7normal! 18|
normal ]!
call IsPosition([7, 18], "no 4 down")
normal [!
call IsPosition([7, 18], "no 4 up")

call vimtest#Quit()
