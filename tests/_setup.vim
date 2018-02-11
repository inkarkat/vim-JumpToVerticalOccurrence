call vimtest#AddDependency('vim-ingo-library')
call vimtest#AddDependency('vim-CountJump')

runtime plugin/JumpToVerticalOccurrence.vim

function! IsPosition( expected, description )
    call vimtap#Is(getpos('.')[1:2], a:expected, a:description)
endfunction
