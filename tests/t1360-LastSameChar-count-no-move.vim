" Test moving with count to non-existing last same character under cursor vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

7normal! 18|
normal 1]!
call IsPosition([7, 18], "no 4 down")
normal 1[!
call IsPosition([7, 18], "no 4 up")

call vimtest#Quit()
