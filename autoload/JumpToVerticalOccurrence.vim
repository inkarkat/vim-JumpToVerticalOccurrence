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
"	001	02-Jan-2014	file creation

function! s:QueriedJump( mode, directionFlag )
    let l:char = ingo#query#get#Char()
    if empty(l:char) | return [0, 0] | endif

    if a:mode ==? 'v'
	" In visual mode, the invocation of the CountJump plugin has positioned
	" the cursor to the start of the selection. We need to re-establish the
	" selection to get the actual original cursor position when the mapping
	" was triggered.
	let l:count = v:count   " Save the given [count] before the normal mode command clobbers it.
	normal! gv
	let l:virtCol = virtcol('.')
	execute 'normal! ' (l:count ? l:count : '') . "\<Esc>"
	" The given [count] is restored by prepending it to the harmless <Esc>
	" command.
    else
	let l:virtCol = virtcol('.')
    endif
    let l:columnCharPattern = printf('\C\V\%%%dv%s', l:virtCol, escape(l:char, '\'))
    return CountJump#CountJump(a:mode, l:columnCharPattern, a:directionFlag . 'W')
endfunction
function! JumpToVerticalOccurrence#QueriedForward( mode )
    return s:QueriedJump(a:mode, '')
endfunction
function! JumpToVerticalOccurrence#QueriedBackward( mode )
    return s:QueriedJump(a:mode, 'b')
endfunction


function! s:CharUnderCursorJump( mode, directionFlag )
    if a:mode ==? 'v'
	" In visual mode, the invocation of the CountJump plugin has positioned
	" the cursor to the start of the selection. We need to re-establish the
	" selection to get the actual original cursor position when the mapping
	" was triggered.
	let l:count = v:count   " Save the given [count] before the normal mode command clobbers it.
	normal! gv
	let l:virtCol = virtcol('.')
	let l:char = ingo#text#GetChar(getpos('.')[1:2])
	execute 'normal! ' (l:count ? l:count : '') . "\<Esc>"
	" The given [count] is restored by prepending it to the harmless <Esc>
	" command.
    else
	let l:virtCol = virtcol('.')
	let l:char = ingo#text#GetChar(getpos('.')[1:2])
    endif
    if empty(l:char) | return [0, 0] | endif

    let l:columnCharPattern = printf('\C\V\%%%dv%s', l:virtCol, escape(l:char, '\'))
    return CountJump#CountJump(a:mode, l:columnCharPattern, a:directionFlag . 'W')
endfunction
function! JumpToVerticalOccurrence#CharUnderCursorForward( mode )
    return s:CharUnderCursorJump(a:mode, '')
endfunction
function! JumpToVerticalOccurrence#CharUnderCursorBackward( mode )
    return s:CharUnderCursorJump(a:mode, 'b')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
