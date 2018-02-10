" Test moving to non-whitespace vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(5)

1normal ]|
call IsPosition([2, 1], "next non-whitespace is down")

1normal! 19|
normal ]|
call IsPosition([4, 19], "next non-whitespace after the gap")

10normal! 12|
normal [|
call IsPosition([6, 12], "previous non-whitespace")

9normal ]|
call IsPosition([12, 8], "next non-whitespace")

25normal! 27|
normal [|
call IsPosition([3, 27], "previous non-whitespace wide across")

call vimtest#Quit()
