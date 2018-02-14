" JumpToVerticalOccurrence.vim: Like f{char}, but searching the same screen column, not line.
"
" DEPENDENCIES:
"   - JumpToVerticalOccurrence.vim autoload script
"   - CountJump/Motion.vim autoload script
"
" Copyright: (C) 2014-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_JumpToVerticalOccurrence') || (v:version < 700)
    finish
endif
let g:loaded_JumpToVerticalOccurrence = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:JumpToVerticalOccurrence_CharUnderCursorMapping')
    let g:JumpToVerticalOccurrence_CharUnderCursorMapping = 'v'
endif
if ! exists('g:JumpToVerticalOccurrence_QueriedMapping')
    let g:JumpToVerticalOccurrence_QueriedMapping = 'V'
endif
if ! exists('g:JumpToVerticalOccurrence_NonWhitespaceMapping')
    let g:JumpToVerticalOccurrence_NonWhitespaceMapping = '<Bar>'
endif
if ! exists('g:JumpToVerticalOccurrence_LastSameCharMapping')
    let g:JumpToVerticalOccurrence_LastSameCharMapping = '!'
endif


"- mappings --------------------------------------------------------------------

if v:version < 702 | runtime autoload/JumpToVerticalOccurrence.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.

call CountJump#Motion#MakeBracketMotionWithJumpFunctions(
\   '', g:JumpToVerticalOccurrence_CharUnderCursorMapping, '',
\   function('JumpToVerticalOccurrence#CharUnderCursorForward'),
\   function('JumpToVerticalOccurrence#CharUnderCursorBackward'),
\   '', '', 0
\)
call CountJump#Motion#MakeBracketMotionWithJumpFunctions(
\   '', g:JumpToVerticalOccurrence_QueriedMapping, '',
\   function('JumpToVerticalOccurrence#QueriedForward'),
\   function('JumpToVerticalOccurrence#QueriedBackward'),
\   '', '', 0
\)
" Additional repeat mappings to avoid the re-query on repeat of the
" operator-pending mappings.
onoremap <Plug>JumpToVerticalOccurrenceQueriedRepeatForward  :<C-u>call call(function('JumpToVerticalOccurrence#QueriedForward'), ['o', 1])<CR>
onoremap <Plug>JumpToVerticalOccurrenceQueriedRepeatBackward :<C-u>call call(function('JumpToVerticalOccurrence#QueriedBackward'), ['o', 1])<CR>

call CountJump#Motion#MakeBracketMotionWithJumpFunctions(
\   '', g:JumpToVerticalOccurrence_NonWhitespaceMapping, '',
\   function('JumpToVerticalOccurrence#NonWhitespaceForward'),
\   function('JumpToVerticalOccurrence#NonWhitespaceBackward'),
\   '', '', 0
\)
call CountJump#Motion#MakeBracketMotionWithJumpFunctions(
\   '', g:JumpToVerticalOccurrence_LastSameCharMapping, '',
\   function('JumpToVerticalOccurrence#LastSameCharForward'),
\   function('JumpToVerticalOccurrence#LastSameCharBackward'),
\   '', '', 0
\)

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
