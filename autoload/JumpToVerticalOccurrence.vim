" JumpToVerticalOccurrence.vim: Like f{char}, but searching the same screen column, not line.
"
" DEPENDENCIES:
"   - ingo/motion/omap.vim autoload script
"   - ingo/query/get.vim autoload script
"   - ingo/text.vim autoload script
"   - CountJump.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"
" Copyright: (C) 2014-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! s:NextLnum( virtCol, pattern, count, offset, beyondLnum )
    let l:lnum = a:beyondLnum + a:offset
    if a:count && a:pattern !~# '^\s$'
	" We had to search for different non-whitespace character in order to
	" skip shorter lines or whitespace at that column. Now, we cannot simply
	" add a:offset; this might be a shorter line or one with whitespace
	" there. In that case, we need to retry until we find a line with a
	" different non-whitespace character.
	" Note: Cannot use search() here; the cursor position hasn't changed
	" yet, and we cannot do so now because of potentially having to revert
	" it.
	let l:nonWhitespacePattern = printf('\C\V\%%%dv\S', a:virtCol)
	while getline(l:lnum) !~# l:nonWhitespacePattern
	    let l:lnum = ingo#lnum#AddOffsetWithWrapping(l:lnum, a:offset)
	endwhile
    endif

    return l:lnum
endfunction
function! s:LastSameJump( virtCol, pattern, count, directionFlag, mode )
    if a:count
	" Search for a different non-whitespace character in the exact column.
	let l:beyondColumnCharPattern = printf('\C\V\%%%dv%s\@!\S', a:virtCol, a:pattern)
    else
	" Search for one of:
	" - a different character in the exact column
	" - a whitespace character just before the column, with no match at it
	" - a shorter line
	let l:beyondColumnCharPattern = printf('\C\V\%%%dv%s\@!\|\%%<%dv\s\%%>%dv\|\%%<%dv\$',
	\   a:virtCol, a:pattern, a:virtCol, a:virtCol, a:virtCol
	\)
    endif

    let l:currentLnum = line('.')
    let l:beyondLnum = search(l:beyondColumnCharPattern, a:directionFlag . 'nw')
    if l:beyondLnum
	if empty(a:directionFlag)
	    let l:lastSameLnum = s:NextLnum(a:virtCol, a:pattern, a:count, -1, l:beyondLnum)
	    if l:lastSameLnum == l:currentLnum
		" We've already been on the last occurrence of the character.
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    elseif l:lastSameLnum < l:currentLnum
		" Search has wrapped around.
		if l:currentLnum < line('$')
		    " Where there are still following lines, move to the last
		    " one.
		    let l:lastSameLnum = line('$')
		elseif l:beyondLnum > 1
		    " When at the last line and there are same columns at the
		    " beginning, wrap around to the last same column at the
		    " beginning of the buffer.
		else
		    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		    return
		endif
	    endif
	else    " backward
	    let l:lastSameLnum = s:NextLnum(a:virtCol, a:pattern, a:count, 1, l:beyondLnum)
	    if l:lastSameLnum == l:currentLnum
		" We've already been on the last occurrence of the character.
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    elseif l:lastSameLnum > l:currentLnum
		" Search has wrapped around.
		if l:currentLnum > 1
		    " Where there are still previous lines, move to the first
		    " one.
		    let l:lastSameLnum = 1
		elseif l:beyondLnum < line('$')
		    " When at the first line and there are same columns at the
		    " end, wrap around to the first same column at the end of
		    " the buffer.
		else
		    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		    return
		endif
	    endif
	endif

	if a:mode ==? 'v'
	    normal! gv
	endif

	normal! m'
	call ingo#cursor#Set(l:lastSameLnum, a:virtCol)
    else
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
    endif
endfunction
function! s:Jump( target, mode, directionFlag )
    let l:count = v:count   " Save the given [count] before the normal mode command clobbers it.

    if a:target ==# 'query'
	let s:char = ingo#query#get#Char()
	if empty(s:char) | return [0, 0] | endif
	let l:char = s:char
    elseif a:target ==# 'repeat'
	let l:char = s:char
    endif

    if a:mode ==? 'v'
	" In visual mode, the invocation of the CountJump plugin has positioned
	" the cursor to the start of the selection. We need to re-establish the
	" selection to get the actual original cursor position when the mapping
	" was triggered.
	normal! gv
    endif

	let l:virtCol = virtcol('.')
	if a:target ==# 'cursor' || a:target ==# 'lastsame'
	    let l:char = ingo#text#GetChar(getpos('.')[1:2])
	endif

    if a:mode ==? 'v'
	execute 'normal! ' (l:count ? l:count : '') . "\<Esc>"
	" The given [count] is restored by prepending it to the harmless <Esc>
	" command.
    endif

    if a:target ==# 'nonwhitespace'
	let l:pattern = '\S'
    else
	let l:pattern = escape(l:char, '\')
    endif
    if empty(l:pattern) | return [0, 0] | endif

    if a:target ==# 'lastsame'
	return s:LastSameJump(l:virtCol, l:pattern, l:count, a:directionFlag, a:mode)
    else
	let l:columnCharPattern = printf('\C\V\%%%dv%s', l:virtCol, l:pattern)
	return CountJump#CountJump(a:mode, l:columnCharPattern, a:directionFlag . 'W')
    endif
endfunction

function! JumpToVerticalOccurrence#QueriedForward( mode, ... )
    let l:operator = v:operator
    let l:count = v:count1
    call s:Jump((a:0 ? 'repeat' : 'query'), a:mode, '')
    if a:mode ==# 'o'
	call ingo#motion#omap#repeat("\<Plug>JumpToVerticalOccurrenceQueriedRepeatForward", l:operator, l:count)
    endif
endfunction
function! JumpToVerticalOccurrence#QueriedBackward( mode, ... )
    let l:operator = v:operator
    let l:count = v:count1
    call s:Jump((a:0 ? 'repeat' : 'query'), a:mode, 'b')
    if a:mode ==# 'o'
	call ingo#motion#omap#repeat("\<Plug>JumpToVerticalOccurrenceQueriedRepeatBackward", l:operator, l:count)
    endif
endfunction

function! JumpToVerticalOccurrence#CharUnderCursorForward( mode )
    return s:Jump('cursor', a:mode, '')
endfunction
function! JumpToVerticalOccurrence#CharUnderCursorBackward( mode )
    return s:Jump('cursor', a:mode, 'b')
endfunction

function! JumpToVerticalOccurrence#NonWhitespaceForward( mode )
    return s:Jump('nonwhitespace', a:mode, '')
endfunction
function! JumpToVerticalOccurrence#NonWhitespaceBackward( mode )
    return s:Jump('nonwhitespace', a:mode, 'b')
endfunction

function! JumpToVerticalOccurrence#LastSameCharForward( mode )
    return s:Jump('lastsame', a:mode, '')
endfunction
function! JumpToVerticalOccurrence#LastSameCharBackward( mode )
    return s:Jump('lastsame', a:mode, 'b')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
