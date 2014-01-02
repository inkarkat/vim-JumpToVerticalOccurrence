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
"	001	02-Jan-2014	file creation

function! s:Jump( source, mode, directionFlag )
    if a:source ==# 'query'
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
	if a:source ==# 'cursor'
	    let l:char = ingo#text#GetChar(getpos('.')[1:2])
	endif

    if a:mode ==? 'v'
	execute 'normal! ' (l:count ? l:count : '') . "\<Esc>"
	" The given [count] is restored by prepending it to the harmless <Esc>
	" command.
    endif

    if empty(l:char) | return [0, 0] | endif
    let l:columnCharPattern = printf('\C\V\%%%dv%s', l:virtCol, escape(l:char, '\'))
    return CountJump#CountJump(a:mode, l:columnCharPattern, a:directionFlag . 'W')
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
