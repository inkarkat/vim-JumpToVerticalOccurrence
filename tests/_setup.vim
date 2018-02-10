call vimtest#AddDependency('vim-ingo-library')

runtime plugin/JumpToVerticalOccurrence.vim

function! IsPosition( expected, description )
    call vimtap#Is(getpos('.')[1:2], a:expected, a:description)
endfunction
