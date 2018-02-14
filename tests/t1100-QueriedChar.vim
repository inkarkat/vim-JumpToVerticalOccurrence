" Test moving to queried character vertically.

edit SameCharColumns.txt

call vimtest#StartTap()
call vimtap#Plan(3)

1normal! 16|
normal ]Vi
call IsPosition([4, 16], "next i")
execute "normal ]V "
call IsPosition([10, 16], "next space")

normal 3]Vl
call IsPosition([14, 16], "third l")

call vimtest#Quit()
