" Manju Rajashekhar ~/.vimrc - vim startup file
"
" @author: Manju Rajashekhar
" @email: manj@cs.stanford.edu
" @lastedited: 07/07/2019
"
" .vimrc
"  `- GENERAL
"  `- PLUGINS
"  `- KEY MAPPINGS
"  `- SYNTAX
"  `- COLORS
"  `- OMNI COMPLETION
"  `- USER INTERFACE
"  `- WINDOWS, BUFFERS AND TABS
"  `- PLUGIN SPECIFIC
"

" GENERAL
" -------
set nocompatible
set history=8196
set encoding=utf-8

" Timeout settings
" Ref: https://meta-serv.com/article/vim_delay
" Ref: https://vi.stackexchange.com/questions/15633/delayed-esc-from-insert-mode-caused-by-cursor-shape-terminal-sequence
set notimeout
set ttimeout
set timeoutlen=2000
set ttimeoutlen=30

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

" When compiled with +clipboard, use "* register as the clipboard; unnamed
" option configures register "" to be the same as the "* register, while
" autoselect option configures visually selected text to "* register.
set clipboard+=unnamed,autoselect

" Backup
set backup
set backupext=~
set backupdir=~/tmp,/tmp

" Search
set incsearch
set ignorecase smartcase
set gdefault

" PLUGINS
" -------
" Ref: https://github.com/junegunn/vim-plug/wiki
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"
call plug#begin('~/.vim/plugged')

" Enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
" Plug 'andymass/vim-matchup'
Plug 'tpope/vim-unimpaired'

" Git
Plug 'tpope/vim-fugitive'

" Edit
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-commentary'

" Browsing
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
    \  if isdirectory(expand('<amatch>'))
    \|   call plug#load('nerdtree')
    \|   execute 'autocmd! nerd_loader'
    \| endif
augroup END

" Fuzzy Finder (fzf)
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Language Support

" Lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" Lsp Asyncomplete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Rust
Plug 'rust-lang/rust.vim'

Plug 'junegunn/goyo.vim'

" Colors
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'yuttie/hydrangea-vim'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'AlessandroYorba/Despacio'
Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'
Plug 'nightsense/snow'
Plug 'nightsense/stellarized'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/seoul256.vim'
Plug 'sjl/badwolf'
Plug 'chriskempson/base16-vim'

call plug#end()

" KEY MAPPINGS
" ------------
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

nnoremap ; :
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" SYNTAX
" ------
filetype plugin indent on
filetype detect

" COLORS
" ------
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

set background=dark
set t_Co=256  

syntax on

" Try: 
" - base16-default-dark
" - base16-twilight
" - base16-eighties
" - base16-tomorrow-night
" - base16-tomorrow-night-eighties
colorscheme base16-default-dark

" OMNI COMPLETION
" ---------------
set completeopt=menuone,preview

" USER INTERFACE
" --------------

" Tabs 
set tabstop=2
set shiftwidth=2
set expandtab smarttab

" Indent
set autoindent
set smartindent
set wrap

set showcmd         " Show (partial) command in status line
set ruler           " Where am I?
set laststatus=2
set noshowmode

set ttyfast
set lazyredraw

set mouse=a         " Enable mouse usage (all modes) in terminals

" Diff
" Ref: https://vimways.org/2018/the-power-of-diff/
set diffopt+=iwhite
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

" WINDOWS, BUFFERS AND TABS
" -------------------------
set hidden
set splitbelow
set splitright

" Circular window naviation
nnoremap <S-tab> <C-w>w
"tnoremap <S-tab> <C-w><C-w>

" Zoom 
nnoremap <leader>z :call <SID>zoom()<CR>
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

" Toggle between buffers (quickly)
nnoremap <leader><leader> <C-^>

" Buffer specific
nnoremap <leader>c :bd<CR>

" Reload .vimrc
nnoremap <leader>x :source $MYVIMRC <bar> redraw <CR>

" Terminal
nnoremap <leader>t :terminal ++rows=10<CR><C-\><C-n><CR>
" tnoremap <C-[> <C-w>N<CR>

" PLUGIN SPECIFIC
" ---------------

" Lightline
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \ },
\ }

" NERDTree
nnoremap <leader>n :NERDTreeToggle<cr>

" Undotree
let g:undotree_WindowLayout = 2
nnoremap <leader>u :UndotreeToggle<CR>

" Fuzzy Finder (fzf)
nnoremap <silent> <leader>p :Files<CR>
nnoremap <silent> <leader>l :Buffers<CR>
nnoremap <silent> <leader>L :Lines<CR>
nnoremap <silent> <leader>; :Rg<CR>
nnoremap <silent> <leader>, :History<CR>
nnoremap <silent> <leader>. :History:<CR>
nnoremap <silent> <leader>/ :History/<CR>

" Lsp
let g:lsp_diagnostics_echo_cursor = 1
nmap <silent> <leader>d <Plug>(lsp-definition)
nmap <silent> <leader>s :split<CR><Plug>(lsp-definition)
nmap <silent> <leader>v :vsplit<CR><Plug>(lsp-definition)
nmap <silent> <leader>h <Plug>(lsp-hover)
nmap <silent> <leader>r <Plug>(lsp-references)
nmap <silent> <leader>i <Plug>(lsp-implementation)
nmap <silent> <leader>f <Plug>(lsp-document-format)
"
" Lsp Autocomplete
let g:lsp_async_completion = 1
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<CR>"

" Rust
augroup rust
  if executable('rls')
    autocmd!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'rls',
      \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
      \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
      \ 'whitelist': ['rust'],
      \ })
    autocmd FileType rust setlocal omnifunc=lsp#complete

    "highlight LspWarningHighlight cterm=underline,bold
    "highlight LspErrorHighlight ctermbg=197
  endif    
augroup END

" Rip Grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Practice key mapping (for manju)
nnoremap <S-q> <Nop>
