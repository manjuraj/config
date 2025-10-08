" vim: set foldmethod=marker foldlevel=0 nomodeline:

" Minimal Settings {{{
set nocompatible

" Switch syntax highlighting on
syntax on

" Use new Regex engine
" https://jameschambers.co.uk/vim-typescript-slow
set re=0

" Make backspace behave in a sane manner
set backspace=indent,eol,start

 " Enable file type detection and do language-dependent indenting
filetype plugin indent on
filetype detect

augroup vimrc
  autocmd!
augroup END

let s:darwin = has('mac')
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" }}}

" Vim Plug {{{

" Ref: https://github.com/junegunn/vim-plug/wiki

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colors
Plug 'joshdick/onedark.vim'
Plug 'junegunn/seoul256.vim'

" Edit
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<CR>
Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 100

" Fuzzy Finder (fzf)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Browsing
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNewFile *
          \ if isdirectory(expand('<amatch>')) |
          \   call plug#load('nerdtree')       |
          \   execute 'autocmd! nerd_loader'   |
          \ endif
  augroup END
  nnoremap <Leader>n :NERDTreeToggle<CR>
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_sort = 0
  nnoremap <Leader>m :TagbarToggle<CR>
Plug 'ludovicchabant/vim-gutentags'
  let g:gutentags_ctags_tagfile = '.git/tags'
  let g:gutentags_ctags_exclude = ['.git']

" Git
Plug 'tpope/vim-fugitive'
  nmap     <Leader>g :Gstatus<CR>gg<C-n>
  nnoremap <Leader>d :Gdiff<CR>

" Make Vim place nicely with iTerm2 and tmux.
Plug 'jszakmeister/vim-togglecursor'
  let g:togglecursor_default = 'blinking_line'
  let g:togglecursor_insert = 'blinking_line'

Plug 'sheerun/vim-polyglot'

" Markdown


" Python

" R

" Scala


" Latex
Plug 'lervag/vimtex'
  let g:tex_flavor = 'latex'
  let g:vimtex_quickfix_mode = 0
  let g:tex_conceal = 'abdmg'


call plug#end()

" }}}

" Basic Settings {{{

set number
set history=8196

" Tabs 
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Indent, Wrap
set autoindent
set smartindent
set wrap
set whichwrap=b,s
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr
set formatoptions+=1,j

set showcmd
set ruler
set laststatus=2
set noshowmode

" Toggle paste mode
set pastetoggle=<Leader>p
nnoremap <Leader>p :set invpaste paste?<CR>

" Search
set ignorecase smartcase
set incsearch
set hlsearch
set gdefault

" No sound on errors
set noerrorbells
set novisualbell
set vb t_vb=

" Timeout settings
" Ref: https://meta-serv.com/article/vim_delay
" Ref: https://vi.stackexchange.com/questions/15633/delayed-esc-from-insert-mode-caused-by-cursor-shape-terminal-sequence
set notimeout
set ttimeout
set timeoutlen=2000
set ttimeoutlen=30

set shortmess=aIT

" When compiled with +clipboard, use "* register as the clipboard; unnamed
" option configures register "" to be the same as the "* register, while
" autoselect option configures visually selected text to "* register.
set clipboard+=unnamed,autoselect

set ttyfast
"set lazyredraw

" Mouse
set mouse=a

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

set autoread

" Use ripgrep for grepping
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Command line completion
set wildmenu
set wildmode=full

" Windows, Buffers, Tabs and Splits
set scrolloff=5
set hidden
set splitbelow
set splitright

" Make the invisible visible
set list
set listchars=tab:\|\ ,

" Backup and Temporary files
set backup
set backupdir=/tmp//,.
set directory=/tmp//,.

" Omni completion
set completeopt+=menuone  " show the popup menu even when there is only 1 match
set completeopt+=noinsert " don't insert any text until user chooses a match
set completeopt-=longest  " don't insert the longest common text"

" Folds
set foldlevelstart=99

set virtualedit=block

" Ctags
set tags=./.git/tags;./tags;/

" Semi-persistent undo
set undodir=/tmp//,.
set undofile

" }}} 

" Status Line {{{

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'
  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" }}}

" Color Settings {{{

let g:terminal_ansi_colors = [
  \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
  \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
  \ '#626262', '#d75f87', '#87af87', '#ffd787',
  \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4']

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237
let g:seoul256_background = 235
silent! colorscheme seoul256

" }}}

" Mappings {{{

nnoremap ; :

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" jk | Escaping!
inoremap jk <Esc>

" Scoll only by half a screen up or down
noremap <C-F> <C-D>
noremap <C-B> <C-U>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
nnoremap Q @q

" TODO: Toggle between buffers (quickly)
" nnoremap <silent> <Leader><Leader> <C-^>

" Circular windows navigation
nnoremap <Tab>   <C-W>w
nnoremap <S-Tab> <C-W>W

" Zoom
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <Leader>z :call <SID>zoom()<CR>

" Disable CTRL-A on tmux or on screen
if &term =~ 'screen'
  nnoremap <C-a> <nop>
  nnoremap <Leader><C-a> <C-a>
endif

" Tags
nnoremap <C-]> g<C-]>
nnoremap g[ :pop<CR>

" }}}

" Fuzzy Finder (Fzf) & Rip Grep (rg) {{{

if exists('$FZF_DEFAULT_OPTS')
  let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS . ' --inline-info'
else
  let $FZF_DEFAULT_OPTS = '--inline-info'
endif
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*" -I'

" Terminal buffer options for fzf
augroup my_fzf_ui
  autocmd!
  autocmd FileType fzf setlocal noshowmode noruler nonumber
augroup END

let g:fzf_colors = { 
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<C-W>\<C-W>" : '').":Files\<CR>"
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>l        :Lines<CR>
nnoremap <silent> <Leader>t        :Tags<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader>;        :History:<CR>
nnoremap <silent> <Leader>/        :History/<CR>

nnoremap <silent> <Leader>f        :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>rg       :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>RG       :Rg <C-R><C-A><CR>
xnoremap <silent> <Leader>rg       y:Rg <C-R>"<CR>

" }}}

" Auto Command {{{

augroup vimrc
  au BufWritePost vimrc,.vimrc nested if expand('%') !~ 'fugitive' | source % | endif
augroup END

" }}}

" Function and Commands {{{

" Chomp
command! Chomp %s/\s\+$// | normal! ``

" }}}
"
