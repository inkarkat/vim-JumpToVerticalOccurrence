" Test moving with count to last same character under cursor vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(4)

1normal! 16|
normal 2]!
call IsPosition([3, 16], "last same e, no change with count")

15normal! 4|
normal 1]!
call IsPosition([22, 4], "move over whitespace with count")

20normal! 22|
normal 1[!
call IsPosition([16, 22], "move over shorter lines with count")

1normal! 14|
normal 1[!
call IsPosition([20, 14], "wrap-around backwards over empty line")

call vimtest#Quit()
