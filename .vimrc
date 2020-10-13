" vim: set tw=7 sw=2 ts=2 foldmethod=marker foldlevel=0 nomodeline:
" Minimal Settings {{{

" Switch syntax highlighting on
syntax on

" Make backspace behave in a sane manner
set backspace=indent,eol,start

 " Enable file type detection and do language-dependent indenting
filetype plugin indent on
filetype detect

" Vim 8 defaults
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

augroup vimrc
	autocmd!
augroup END

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

" Fuzzy Finder (fzf)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Browsing
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
      \  if isdirectory(expand('<amatch>'))
      \|   call plug#load('nerdtree')
      \|   execute 'autocmd! nerd_loader'
      \| endif
  augroup END
  nnoremap <Leader>n :NERDTreeToggle<CR>

" Git
Plug 'tpope/vim-fugitive'
  nmap     <Leader>g :Gstatus<CR>gg<C-n>
  nnoremap <Leader>d :Gdiff<CR>

call plug#end()

" }}}

" Basic Settings {{{

set number
set history=8196

" Tabs 
set tabstop=2
set shiftwidth=2
set expandtab smarttab

" Indent
set autoindent
set smartindent
set wrap
set whichwrap=b,s

set showcmd
set ruler
set laststatus=2
set noshowmode

" Search
set ignorecase smartcase
set incsearch
set hlsearch
set gdefault

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

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
set lazyredraw

" Mouse
set mouse=a

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

silent! colorscheme seoul256

" Use ripgrep for grepping
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Windows, Buffers, Tabs and Splits
set hidden
set splitbelow
set splitright

" Backup
set backup
set backupext=~
set backupdir=~/tmp,/tmp

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

" Mappings {{{

nnoremap ; :

" Toggle between buffers (quickly)
nnoremap <silent> <Leader><Leader> <C-^>

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

" }}}

" Fuzzy Finder (Fzf) & Rip Grep (rg) {{{

let $FZF_DEFAULT_OPTS .= ' --inline-info'
let $FZF_DEFAULT_COMMAND = 'rg --files --follow'

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonumber

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

nnoremap <silent> <expr> <Leader>p (expand('%') =~ 'NERD_tree' ? "\<C-W>\<C-W>" : '').":Files\<CR>"
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>l        :Lines<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> q:               :History:<CR>
nnoremap <silent> q/               :History/<CR>

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
