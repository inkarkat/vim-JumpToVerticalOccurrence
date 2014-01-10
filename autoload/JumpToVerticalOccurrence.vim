" JumpToVerticalOccurrence.vim: Like f{char}, but searching the same screen column, not line.
"
" DEPENDENCIES:
"   - ingo/query/get.vim autoload script
"   - ingo/text.vim autoload script
"   - CountJump.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	03-Jan-2014	Implement jump to character under cursor
"				variant.
"				Implement jump to non-whitespace character in
"				the same column.
"	001	02-Jan-2014	file creation

function! s:LastSameJump( virtCol, pattern, count, directionFlag, mode )
    if l:count
	" Search for a different non-whitespace character in the exact column.
	let l:beyondColumnCharPattern = printf('\C\V\%%%dv%s\@!\S', a:virtCol, a:pattern)
    else
	" Search for one of:
	" - a different character in the exact column
	" - a whitespace character just before the column, with no match at it
	" - a shorter line
	let l:beyondColumnCharPattern = printf('\C\V\%%%dv%s\@!\|\%%<%dv\s\%%>%dv\|\%%<%dv$',
	\   a:virtCol, a:pattern, a:virtCol, a:virtCol, a:virtCol
	\)
    endif

    let l:beyondLnum = search(l:beyondColumnCharPattern, a:directionFlag . 'nw')
    let l:lastSameLnum = l:beyondLnum + (empty(a:directionFlag) ? -1 : 1)
    if l:lnum && (
    \   empty(a:directionFlag)  && l:lastSameLnum > line('.') ||
    \   a:directionFlag ==# 'b' && l:lastSameLnum < line('.')
    \)
    else
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
    endif
endfunction
function! s:Jump( target, mode, directionFlag )
    if a:target ==# 'query'
	let l:char = ingo#query#get#Char()
	if empty(l:char) | return [0, 0] | endif
    endif

    if a:mode ==? 'v'
	" In visual mode, the invocation of the CountJump plugin has positioned
	" the cursor to the start of the selection. We need to re-establish the
	" selection to get the actual original cursor position when the mapping
	" was triggered.
	let l:count = v:count   " Save the given [count] before the normal mode command clobbers it.
	normal! gv
    endif

	let l:virtCol = virtcol('.')
	if a:target ==# 'cursor'
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

function! JumpToVerticalOccurrence#QueriedForward( mode )
    return s:Jump('query', a:mode, '')
endfunction
function! JumpToVerticalOccurrence#QueriedBackward( mode )
    return s:Jump('query', a:mode, 'b')
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
