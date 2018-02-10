" Test moving to same character under cursor vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(3)

1normal! 20|
normal ]v
call IsPosition([2, 20], "in next line")
normal ]v
call IsPosition([25, 20], "skip several lines")

normal 2[v
call IsPosition([1, 20], "back to start")

call vimtest#Quit()
