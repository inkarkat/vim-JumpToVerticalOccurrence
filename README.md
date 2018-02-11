JUMP TO VERTICAL OCCURRENCE   
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

The f / F commands allow you to quickly go to next / previous occurrences
of a character in the same line (with plugins also across lines), but are
limited to horizontal movement. But vertical movement, restricted to the same
screen column the cursor is in, across lines would often be helpful, too.

This plugin provides a |]V|{char} mapping that works just like f, but
vertically. The ]v mapping is similar, but uses the character under the
cursor instead of querying for it (which is a more common use case when moving
vertically).
The ]| mapping is helpful for jumping out of indented blocks, or to filled-out
columns, as it moves to the next non-whitespace in the current column.
In long sorted lists, one often wants to go to the first / last instance of
the current character (e.g. to move from "[A]ddress" to "Aardvark" or the last
"Azure" before the entries with "B" begin). The ]! mapping does that.

### SOURCE

- [The ]| mapping was inspiration](http://stackoverflow.com/questions/20882722/move-to-the-next-row-which-has-non-white-space-character-in-the-same-column-in-v)

### SEE ALSO

- The JumpToLastOccurrence.vim plugin ([vimscript #3386](http://www.vim.org/scripts/script.php?script_id=3386)) still moves
  horizontally in the same line, but counts the characters in reverse,
  starting from the last one.
- Check out the CountJump.vim plugin page ([vimscript #3130](http://www.vim.org/scripts/script.php?script_id=3130)) for a full list
  of motions and text objects powered by it.

### RELATED WORKS

- columnmove ([vimscript #4880](http://www.vim.org/scripts/script.php?script_id=4880)) defines f/t/;/, commands as well as w/e/b/ge
  commands that work vertically, either skipping or opening closed folds.
- columnMove ([vimscript #5402](http://www.vim.org/scripts/script.php?script_id=5402)) moves to the end / start of vertical blocks of
  non-whitespace.

USAGE
------------------------------------------------------------------------------

    ]v                  To [count]'th occurrence of the character under the cursor
                        in the same screen column of following lines.
    [v                  To [count]'th occurrence of the character under the cursor
                        in the same screen column of previous lines.

    ]V{char}            To [count]'th occurrence of {char} in the same screen
                        column of following lines. Like f, but vertically.
    [V{char}            To [count]'th occurrence of {char} in the same screen
                        column of previous lines. Like F, but vertically.
                        You can quickly repeat the same motion via the ]v / [v
                        mappings (like ; / , for f).

    ]|                  To [count]'th next line that has non-whitespace in the
                        same column as the current one.
    [|                  To [count]'th previous line that has non-whitespace in the
                        same column as the current one.

    ]!                  To the last continuous occurrence of the character under
                        the cursor in the same screen column. With any [count],
                        skips over whitespace and shorter lines.
    [!                  To the first continuous occurrence of the character under
                        the cursor in the same screen column. With any [count],
                        skips over whitespace and shorter lines.
                        Mnemonic: The ! looks like a column, with the dot marking
                        the jump target.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-JumpToVerticalOccurrence
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim JumpToVerticalOccurrence*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the CountJump plugin ([vimscript #3130](http://www.vim.org/scripts/script.php?script_id=3130)), version 1.60 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.034 or
  higher.
- repeat.vim ([vimscript #2136](http://www.vim.org/scripts/script.php?script_id=2136)) plugin (optional)

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To change the default motion mappings, use:

    let g:JumpToVerticalOccurrence_CharUnderCursorMapping = 'v'
    let g:JumpToVerticalOccurrence_QueriedMapping = 'V'
    let g:JumpToVerticalOccurrence_NonWhitespaceMapping = '<Bar>'
    let g:JumpToVerticalOccurrence_LastSameCharMapping = '!'

To also change the [ / ] prefix to something else, follow the instructions for
CountJump-remap-motions.

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-JumpToVerticalOccurrence/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 1.01    RELEASEME
- BUG: ]! on a single occurrence of a character in that column mistakenly
  jumps to end of buffer.
- BUG: <count>]! may jump too far and land on whitespace instead of the last
  line that contains the current character at the current column.
  __You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.034!__

##### 1.00    22-Jan-2014
- First published version.

##### 0.01    02-Jan-2014
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2014-2018 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat <ingo@karkat.de>
