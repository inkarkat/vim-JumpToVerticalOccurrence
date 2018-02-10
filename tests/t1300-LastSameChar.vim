" Test moving to last same character under cursor vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(7)

1normal! 16|
normal ]!
call IsPosition([3, 16], "last same e")

6normal! 9|
normal [!
call IsPosition([1, 9], "same character all up to first line")

6normal! 9|
normal ]!
call IsPosition([8, 9], "last backslash")

22normal! 10|
normal ]!
call IsPosition([26, 10], "last w in buffer")
normal ]!
call IsPosition([6, 10], "wrap-around forward")

3normal! 15|
normal [!
call IsPosition([1, 15], "first b in buffer")
normal [!
call IsPosition([25, 15], "wrap-around backward")

call vimtest#Quit()
