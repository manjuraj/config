" ~/.vimrc - vim startup file
"
" @author: Manju Rajashekhar
" @email: manj@cs.stanford.edu
" @lastedited: 08/13/2016
"
" .vimrc
"  `- General
"  `- Notes
"  `- Read, Write, Append, Compile
"  `- Moving Around
"  `- Marking/Named-Marks
"  `- Look and Feel
"  `- Filetype
"  `- Backing-up Files
"  `- Record And Repeat
"  `- Search
"  `- Replace
"  `- Omni Completion
"  `- User Interface
"  `- Windows and Buffers
"  `- Registers
"  `- Key Mappings
"
" .vim/
" `- Added syntax, filetype and indentation plugin for Scala
" `- Added syntax, filetype and indentation plugin for GO
" `- Changed syntax/go.vim to contain "set noexpandtab"
"
set nocompatible

" PATHOGEN
" --------
" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
"
execute pathogen#infect()
call pathogen#helptags()

" PLUGINS
" --------
"
" vim-markdown
" cd ~/.vim/bundle && git clone git@github.com:plasticboy/vim-markdown.git
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_initial_foldlevel=6
let g:vim_markdown_no_default_key_mappings=1
set nofoldenable
"
" ctrl-p
" cd ~/.vim/bundle && git clone git@github.com:ctrlpvim/ctrlp.vim.git
let g:ctrlp_working_path_mode = 'ra'
" <c-d> inside to prompt to toggle searching by filename or full path
let g:ctrlp_by_filename = 0
" <c-r> inside to prompt to toggle searching by regexp
let g:ctrlp_regexp = 1
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:12,results:12'
set wildignore+=*/tmp/*,*/target/*,*.o,*.so,*.class,*.swp,*.zip,*.tar,*/.git/*,*/.hg/*,*/.svn/*
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
nmap <silent> ,f :CtrlP<cr>
nmap <silent> ,b :CtrlPBuffer<cr>
nmap <silent> ,m :CtrlPMixed<cr>
"
" vim-scala
" cd ~/.vim/bundle && git clone git@github.com:derekwyatt/vim-scala.git
"
" cd ~/.vim/bundle && git clone git@github.com:flazz/vim-colorschemes.git
"
" neocomplete
" cd ~/.vim/bundle && git clone git@github.com:Shougo/neocomplete.vim.git
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 0
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"
inoremap <expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" GENERAL
" -------
"
" Sets how many lines of history VIM has to remember
set history=8196
"
" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc
"
" Command to find out all the scripts file related to vim.
":scriptname
"
" Command mentioning the name of user's vimrc file.
":version
"
" Option window
":options
"
" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

" NOTES
" -----
"
" Modes
" - command
" - insert
"
" Change the case of the character under the cursor
" - use ~
"
" To forbid any changes in the file use
" vim -M <file-name>
"
" Open a file in read only mode
" vim -R <file-name>
"
" Skip startup file
" vim -u NONE <file-name>
"
" Run a shell command
" :!command
"
" Save the current file to under different name
" :w <file-name>
"
" Append the current file to another file
" :w >> <file-name>
" :n,mw >> <file-name>
"
" vimtutor
":help tutor
"
" Increment or Decrement Number
" <C-a> - increment number under the cursor
" <C-x> - decrement number under the cursor
"
" Parentheses Matching
" - use %
"
" Go to the man page for the word currently under the cursor
" - use K
"
" Indent and Unindent higlighted code
" [count] >> to indent
" [count] << to unindent
"
" Keys (insert mode)
" i         insert text to the left of the current character
" I         insert text at the beginning of the current line
" a         insert text to the right of the current character
" A         insert text at the end of the current line
" o         create a new line under the current one and insert text there
" O         create a new line above the current one and insert text there
" c{motion} delete (change) the text moved over by {motion} and insert text
"           to replace it. For instance, c$ would delete the text from the
"           cursor to the end of the line and enter insert mode. ct! would
"           delete the text from the cursor "up to (but not including) the
"           next exclamation mark and enter insert mode
" d{motion} delete the text moved over by {motion} -- same as c{motion}, but
"           doesn't enter insert mode
" y{motion} copy the text moved over by {motion}
" dd        cut the current line
" yy        copy the current line
" cc        cut the current line and leave the editor in insert mode
" x         cut the current character.
" s         cut the current character and leave the editor in insert mode
" dw        delete a word from the current cursor position
" daw       delete a word (including white space) regardless of the cursor position
" diw       delete a word (excluding white space) regardless of the cursor position
" cs        change sentence from the current cursor position
" cas       change sentence regardless of the cursor position
" cis       change inner sentence regardless of the cursor position
" dp        delete paragraph from the current cursor position
" dap       delete paragraph
" dip       delete inner paragraph
" [cd]a"    double quoted string
" [cd]i"    inner double quoted string
" [cd]a'    single quoted string
" [cd]i'    inner single quoted string
" [cd]a`    back quoted string
" [cd]i`    inner back quoted string
" [cd]a)    parenthesized block
" [cd]i)    inner parenthesized block
" [cd]a]    bracketed block
" [cd]i]    inner bracketed block
" [cd]a}    closing brace
" [cd]i}    inner closing brace
" [cd]at    tag block
" [cd]it    inner tag block
" [cd]%     change or delete till closing parenthesis (')', ']', or '}')
" yas       yank a sentence
" {         move to the beginning of a paragraph
" }         move to the end of a paragraph
" y{        yank from the current cursor to beginning of this paragraph
" y}        yank from the current cursor to end of this paragraph
" d5}       delete from the current cursor through the end of the fifth paragraph
" dtx       delete from the current cursor to the first appearence of  character x
" d/foo     cut from the current line to the next line containing string foo
" y?bar     copy from the current line to the previous line containing bar
" 3J        join the next three lines
"
" Selection
" v     character selection mode
" V     line selection mode
" C-v   column selection mode
" =     indent visually selected block
" >     tab shift visually selected block
"
" 'c' is same as 'd' except it leaves you in insert mode
"
" <C-v> I{string} <ESC>
" - visual block insert; insert {string} at the start of block on every line
"   of block, provided that the line extends into the block.
" <C-v> A{string} <ESC>
" - visual block append; append {string} to the end of the block on every line
"   of block
" <C-v> >
" - visual block shift
"
" Pull all scala files in the entire source tree
":args **/*.scala
" - ** means recursively go down 30 directories (by default)
" - :help **
"
":argdo exe "normal gg=G" | w
" - :argdo tells it to run the specified command on all "args", or all open files
" - exe tells it to execute the given command
" - normal runs the :normal command, which allows you to execute normal mode commands like motions, etc
" - gg goes to the top of the file
" - = formats the file (= is the 'equalprg'
" - G goes to the end of the file
" - | chains commands together
" - w writes the file
"
":argdo %s/<matchon>/<replacewith>/ge | w
" - :argdo is to run a search and replace across many files
"

" READ, WRITE, APPEND, COMPILE
" ----------------------------
"
":w <file-name>
" - to write the contents of current file to <file-name>
":w >> <file-name>
" - to append all the contents from the current file to <file-name>
"
":r <file-name>
" - to read the contents of <file-name>
":r! <cmd>
" - insert output of command <cmd> below the cursor
"
":redir>f
" - redirect the output to a file [assuming the file as a script]
"

" MOVING AROUND
" -------------
"
" Move to a specific line
" - gg, 1G  - start of file
" - G       - end of file
" - <num>G  - to the line <num> in file
" - 50%     - move halfway the file
"
" Move to a specific section in the current window
" - H   - top of the screen (home)
" - M   - middle of the screen
" - L   - bottom of the screen (last)
"
" Where-am-i?
" ctrl-g
"
" Jump to older position
" - [count] <C-o>
" Jump to newer position
" - [count] <C-i>
" Print the jump list
" :jumps
"
" Scroll window half a screen up or down
" - <C-u> <C-d>
" Scroll window by whole screen forward or backward
" - <C-f>, <C-b>
" Scroll one line at a time
" - <C-e>, <C-y>
"
" Change cursor context; one of the common issues is that after moving
" many lines with 'j' your cursor is at the bottom of the screen:
" - use 'zz' to see context of lines around cursor
"   use 'zt' to put the cursor line at the top
"   use 'zb' to put the cursor line at the bottom
"
" f<char>  move the cursor forward to the next occurance of the character
" F<char>  move the cursor backward
" w        move the cursor forward by a word
" b        move the cursor backward by a word
" 0        move the cursor to the beginning of the current line
" ^        move the cursor to the first character on the current line
" $        move the cursor to the end of the line
" )        move the cursor forward to the next sentence
" ( Move the cursor backward by a sentence
"

" MARKING/NAMED-MARKS
" -------------------
"
" Place a named mark
" - m<{a-z}> or m<{A-Z}
" Jump to a named mark
" - '{mark} or `{mark}, where {mark} is the mark letter.
":marks
" - Display active mark list

" LOOK AND FEEL
" -------------
"
syntax on
syntax enable
set background=dark
"colorscheme ron
"
":set list
" Enables visualizing of tabs, spaces and line ending
":set listchars=tab:>.ddeol:$,extends:+,trail:= "$
" - eol: the character to show end of the line
" - tab: the characters use to show a tab. Two characters are used: the second
"   will be repeated for each space
" - trail: character to show for trailing spaces

" FILETYPE
" --------
"
" Enable filetype detection; detects the type of the file by checking
" the filename and sometimes the contents of the file for specific
" text
filetype on
"
" Turn on the file type plugin
filetype plugin on
"
" Use this if you have started with an empty file and typed text that
" makes it possible to detect the type of text
filetype detect

" BACKING-UP FILES
" ----------------
"
set backup
set backupext=~
" - The name of the backup file is the original file with ~ added to the
"   end. If your file is data.txt, then backup file is data.txt~
"
set backupdir=~/tmp,/tmp
" - List of directories for the backup file
" - Backup file will be created in the first directory in the list when it
"   is possible
" - Backup files are written each time your original source file is written;
"   thus a backup file will only contain the previous version of the file
"   not the first version
"
" set patchmode=.org
" - To make vim keep the original file i.e the first backup file used
"

" RECORD AND REPEAT
" -----------------
"
" Start recording - q{0-9a-zA-Z}
" Stop recording  - q
" Repeat          - [count] @{0-9a-z".=*}
"
" Note that macros just record your keystrokes and play them back
"
" '.' (dot) command
" - Repeat a previous change
" - '.' command works for all changes you make, except for the 'u' (undo) and
"   ctrl-r (redo) and commands that start with a colon (:)
"

" SEARCH
" ------
"
" Search forward  /search
" Search backward ?search
"
" Whole word search (under the cursor)
" - * for forward search
" - # for backward search
"
" Searching for whole words by delineating words using markers
" - \< as start-of-word marker
" - \> as end-of-word marker
"set ic
" - Set [no]ic for case (in)sensitive searches and replaces
"
set hlsearch
" - Set [no]hlsearch, for highlighting matches
"
set incsearch
" - Set [no]incsearch, for incremental searches
"
" set nowrapscan
" - Enable search to wrap around the end of the file
"
set showmatch
" - When a bracket is inserted, briefly jump to the matching one
"
" Examples
" \(\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)\.\)\{3\}\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)   " match IP address
"
" fx - move the cursor the next occurrence of character x
" Fx - move the cursor to the previous occurrence of character x
"

" REPLACE
" -------
" http://vim.wikia.com/wiki/Search_and_replace
" http://vimregex.com/
" help :s
"
" Text substitution
":[range]s[ubstitute]/{pattern}/{string}/[flags]
"
" [range]
"<empty> select current line
" %      select all lines
" .      select current line
" $      select last line
" M,N    select all lines from M to N
" 0,N    select all lines from 0 to N
" M,$    select all lines from M to last line
" 'a     select line with mark 'a
" 'a,'b  select all lines between marks 'a and 'b
"
" {pattern}
" \<{word}\>        select whole word
" \(word1\|word2\)  select word1 or word2
"
" Metacharacters
" .                 matches any character except new line
" \s                matches whitespace character
" \S                matches non-whitespace character
" \d                matches digit
" \D                matches non-digit
" \x                matches hex digit
" \X                matches non-hex digit
" \o                matches octal digit
" \O                matches non-octal digit
" \h                matches head of word character (a,b,c...z,A,B,C...Z and _)
" \H                matches non-head of word character
" \p                matches printable character
" \P                matches like \p, but excluding digits
" \w                matches word character
" \W                matches non-word character
" \a                matches alphabetic character
" \A                matches non-alphabetic character
" \l                matches lowercase character
" \L                matches non-lowercase character
" \u                matches uppercase character
" \U                matches non-uppercase character
"
" Quantifiers
" .*                matches everything (greedy matching)
" .\{-}             matches everything (non-greedy matching)
"
" *                 matches 0 or more of the preceding characters, ranges or metacharacters
"                   .* matches everything including empty line
" \+                matches 1 or more of the preceding characters
" \=                matches 0 or 1 more of the preceding characters
" \{n,m}            matches from n to m of the preceding characters
" \{n}              matches exactly n times of the preceding characters
" \{,m}             matches at most m (from 0 to m) of the preceding characters
" \{n,}             matches at least n of of the preceding characters
"
" \{-}              matches 0 or more of the preceding atom, as few as possible (non-greedy)
" \{-n,m}           matches 1 or more of the preceding characters
" \{-n,}            matches at lease or more of the preceding characters
" \{-,m}            matches 1 or more of the preceding characters
"
" Grouping and Backreferences
" {string}
" &   replace with the whole matched pattern
" \0  replace with the whole matched pattern
" \1	replace with the matched pattern in the first pair of ()
" \2	replace with the matched pattern in the second pair of ()
" ..
" \r	carriage return (^M) = <CR> = / C-v <Enter>
" \n  new line
" \t	tab
" \s  white space = [\ \t]
"
" [flags]
" [c] Confim each substitution
" [g] Replace all occurrences in the line (global substitution)
" [i] Ignore case for the pattern
" [n] Report the number of matches, do not actually substitute
"
" When doing a search or replace
" ., *, \, [, ], ^, and $ are metacharacters
" +, ?, |, {, }, (, and ) must be escaped to use their special function
" % is a synonymous with :1,$ (all lines)
"
" Visual substitution
" - In visual mode enter ':' = :'<,'>s/{pattern}/{string}
"
" Examples
" :%s/\s\+$//                   " trim blanks and spaces at the end of every line
" :%s/\n//g                     " remove newline
" :%s/^\s*\n//g                 " remove empty lines
" :%s/\(\n\n\)\n\+/\1/          " replace multiple blank lines with a single blank line
" :.,12s/foo/bar                " replace foo to bar from current line to line number 12
" :.,+12s/foo/bar               " replace foo to bar from current to 12 lines ahead
" :s/\(\(a[a-d] \)*\)/\2/       " modifies 'aa ab x' to 'ab x'
" :s/\([ab]\)\|\([cd]\)/\1x/g   " modifies 'a b c d'  to 'ax bx x x'
" :s/a\|b/xxx\0xxx/g            " modifies 'a b' to 'xxxaxxx xxxbxxx'
" :s/\([abc]\)\([efg]\)/\2\1/g	" modifies 'af fa bg' to 'fa fa gb'
" :s/abcde/abc^Mde/             " modifies 'abcde' to 'abc', 'de' (two lines)
" :s/$/\^M/                     " modifies 'abcde' to 'abcde^M'
" :s/\w\+/\u\0/g                " modifies 'bla bla' to 'Bla Bla'
" :s/a.\{-}//                   " modified 'abcdef' to 'bcdef' (non-greedy matching)
" :s/a.*//                      " modified 'abcdef' to '' (greedy matching)
" :windo 2s/\(.*\)/XYZ.\r/      " 'windo' operates on all windows and adds 'XYZ.' at line 2 of every file
"

" OMNI COMPLETION
" ---------------
"
set ofu=syntaxcomplete#Complete
" Below keys trigger completion when in insert mode
"C-n      word completion (forward)
"C-p      word completion (backward)
"C-x C-o  omni completion
"C-x C-l  line completion
"C-x C-f  file completion

" USER INTERFACE
" --------------
"
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set number
set wrap
set showcmd
"
set laststatus=2
" always display status line, even if there is one window
"
set ruler
"
set hidden
" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)

" WINDOWS AND BUFFERS
" -------------------
"
" C-w n  Creates a new window above the current window
" C-w j  Moves the cursor to the window below the current one
" C-w k  Moves the cursor to the window above the current one
" C-w o  Make the current window the only window. Closes all other windows
"

" REGISTERS
" ---------
"
" Precede the command with "x, x is the one-character register name.
"

" KEY MAPPINGS
" ------------
" - n  Normal mode map. Defined using ':nmap' or ':nnoremap'.
" - i  Insert mode map. Defined using ':imap' or ':inoremap'.
" :help map-modes
"
nmap <silent> <C-C> :nohlsearch<C-M>
nmap <silent> <C-j> <C-w>j<C-w>
nmap <silent> <C-k> <C-w>k<C-w>
nmap <C-l> :buffers<CR>:buffer<Space>

"
" VIM COLORS
" ----------
"
" http://www-2.cs.cmu.edu/~maverick/VimColorSchemeTest/index-c.html
" - Screen shots of various colorschemes
"
" various color schemes
" - pablo, koehler, desert, darkblue, torte,
"   elflord (best when doing perl)
"   murphy, zellner
"   astronaut, xterm16, elflord, oceandeep,
"   dawn, dusk, oceanblack, Bookstream, tomatosoup
"   denim, darkslategray, navajo, matrix

" VIM PLUGINS (VIM MACROS)
" ------------------------
set tags=.tags;/

" NO-TIME HACKS
" -------------
"
" ctags.vim - 'bar' at the bottom of my view window, showing the file-name,
" row number, col number
" Before sourcing the script do:
"    let g:ctags_path='/usr/local/bin/ctags'
"    let g:ctags_args='-I __declspec+'
"        (or whatever other additional arguments you want to pass to ctags)
"    let g:ctags_title=1		" To show tag name in title bar.
"    let g:ctags_statusline=1	" To show tag name in status line.
"    let generate_tags=1	" To start automatically when a supported
"				" file is opened.
":set columns=79
"
" **TWITTER
" autocmd BufWritePre *.scala :%s/\s+$//e

" VIM CLIPBOARD
" ------------
" requires vim to be compiled with +clipboard
" use "*yG to yank everything in file - use double-quote asterix before any yank command
" use "*p to paste in vim
"
" add the unnamed register to the clipboard
set clipboard+=unnamed

" scala
autocmd FileType scala :setlocal sw=2 ts=2 sts=2

" python
autocmd FileType python :setlocal sw=4 ts=4 sts=4

map Q :qa<CR>

" CHECKLIST
" ---------

" REFERENCES
" ----------
" - http://www.oualline.com/vim-cook.html
" - http://nvie.com/posts/how-i-boosted-my-vim/
" - http://learnvimscriptthehardway.stevelosh.com/
if &diff
    colorscheme monokai
endif

autocmd BufNewFile,BufRead *.ont  set syntax=conf
autocmd BufNewFile,BufRead *.rules set syntax=json
