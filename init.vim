""" Neovim configuration loader
" Define global configuration and source user configuration script.
"
" NB: this configuration rely on dein to manage plugins. Dein.vim is loade in
" the git repository as submodule.
" To force plugins update: `call dein#clear_state()` or `call dein#update()`
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set all&  " reset everything to their defaults

""" Leader and path configuration {{{
let g:mapleader = ' '
let g:nvim_dflt_indent = 2
let g:nvim_max_col = 80

let g:sps='/' " abrv for system path separator
let g:nvim_dir= '~' . g:sps . 'cnfNvimTmux'
let g:cnf_dir= g:nvim_dir . g:sps . 'cnfNvim'
let g:cache_dir = g:nvim_dir . g:sps . 'cache'
let g:md_wiki = g:nvim_dir . g:sps . 'wiki_md'
let g:tex_wiki = g:nvim_dir . g:sps . 'wiki_md'
""" }}}

""" Utility functions {{{
function! init#FromCnfDir(suffix) "{{{
  return resolve(expand(g:nvim_dir . g:sps . a:suffix))
endfunction "}}}
function! init#FromCacheDir(suffix) "{{{
  return resolve(expand(g:cache_dir . g:sps . a:suffix))
endfunction "}}}
function! init#EnsureExists(path) "{{{
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction "}}}
function! init#SourceSubCnf(name) "{{{
	execute 'source ' . g:cnf_dir . g:sps . a:name
endfunction "}}}
""" }}}

""" Plugin manager (Used dein.vim from Shougo) {{{
  let s:dein_path = init#FromCnfDir('bundle/repos/github.com/Shougo') . g:sps . 'dein.vim'
  execute 'set runtimepath+=' . s:dein_path
  call dein#begin(init#FromCnfDir('bundle'))
  call dein#add(s:dein_path)
""" }}}

""" vim-leader configuration  {{{
function! init#VimLeaderDsp() " {{{
  let g:leaderGuide#displayname =
      \ substitute(g:leaderGuide#displayname, '\c<CR>$', '', '')
  let g:leaderGuide#displayname =
      \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
  let g:leaderGuide#displayname =
      \ substitute(g:leaderGuide#displayname, '^<SID>', '', '')
endfunction
" }}}
call dein#add('hecal3/vim-leader-guide')
" Dictonnary for leader map
let g:lmap = {}
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
let g:leaderGuide_displayfunc = [function("init#VimLeaderDsp")]
" Position Bottom
let g:leaderGuide_vertical = 0
let g:leaderGuide_position = 'botright'
" Master leaderGuide shortcuts
nnoremap <silent><nowait> <Leader> :<C-u>LeaderGuide '<Space>'<CR>
vnoremap <silent><nowait> <Leader> :<C-u>LeaderGuideVisual '<Space>'<CR>
" map <Leader>. <Plug>leaderguide-globalmap
""" }}}

""" Native editor configuration {{{
" Various {{{
" Smash escape 
inoremap jk <Esc>
inoremap kj <Esc>
" Smash escape in neoterm
" tnoremap <Esc> <C-\><C-n> "disable it for use of bash vi mode in nvim terminal emulator
tnoremap jk <C-\><C-n>
tnoremap kj <C-\><C-n>

" Timeout
set timeoutlen=300  " mapping timeout
set ttimeoutlen=50  " keycode timeout
" Mouse
set mouse=a  " enable mouse
set mousehide  " hide when characters are typed

" History & clipboard and buffers
set history=1000  " number of command lines to remember
set clipboard=unnamed  " sync with OS clipboard

" Various TTY config
set ttyfast  " assume fast terminal connection
set viewoptions=folds,options,cursor,unix,slash  " unix/windows compatibility
set nrformats-=octal  " always assume decimal numbers
set showcmd
set modeline
set modelines=5
set noshelltemp  " use pipes

" Hidden buffer
set hidden  " allow buffer switching without saving
set autoread  " auto reload if file saved externally

" Whitespace
set backspace=indent,eol,start  " allow backspacing everything in insert mode

" Tabulation char
set smarttab  " use shiftwidth to enter tabs
set autoindent  " automatically indent to match adjacent lines
" the amount of indent for a continuation line for vim script
let g:vim_indent_cont = &shiftwidth * 2

" Indentation <http://vim.wikia.com/wiki/Indenting_source_code>
set expandtab
let &shiftwidth = g:nvim_dflt_indent
let &tabstop = g:nvim_dflt_indent
let &softtabstop = g:nvim_dflt_indent

" Highlight whitespace
set list
set shiftround
set linebreak

" Scrolling
set scrolloff=10  " minimum number of lines above and below cursor
set scrolljump=1  "minimum number of lines to scroll
set sidescrolloff=5  " minimum number of columns to left and right of cursor
set display+=lastline

" Autocomplete and excluded pattern
set wildmenu
set wildmode=list:full
set wildignore+=*~,*.o,core.*,*.exe,.git/,.hg/,.svn/,.DS_Store,*.pyc
set wildignore+=*.swp,*.swo,*.class,*.tags,tags,tags-*,cscope.*,*.taghl
set wildignore+=.ropeproject/,__pycache__/,venv/,*.min.*,images/,img/,fonts/
set wildignorecase

" Recursive search
set path+=**

" disable sounds
set noerrorbells
set novisualbell
set t_vb=

" searching
set hlsearch  " highlight searches
set incsearch  " incremental searching
set ignorecase  " ignore case for searching
set smartcase  " do case-sensitive if there's a capital letter
""" }}}

" Persistent undo, backup and swap {{{
call init#EnsureExists(g:cache_dir)
" undo
if exists('+undofile')
  set undofile
  let &undodir = init#FromCacheDir('undo')
endif
call init#EnsureExists(&undodir)

" backups
set backup
let &backupdir = init#FromCacheDir('backup')
call init#EnsureExists(&backupdir)

" swap files
let &directory = init#FromCacheDir('swap')
set noswapfile
call init#EnsureExists(&directory)
"}}}

" Ui configuration {{{
set showmatch  " highlight matching braces/brackets/etc.
set matchtime=2  " tens of a second to show matching parentheses
set number
set relativenumber
set lazyredraw
set laststatus=2
set noshowmode
set foldenable  " enable folds by default
set foldmethod=marker  " fold marker
set foldlevelstart=99  " open all folds by default

" Cursor line and column
set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
let &colorcolumn = g:nvim_max_col
set cursorcolumn
autocmd WinLeave * setlocal nocursorcolumn
autocmd WinEnter * setlocal cursorcolumn

" Coloration
filetype plugin indent on
syntax on
"}}}
""" }}}

""" UI themes {{{
" spaceVim {{{
call dein#add('liuchengxu/space-vim-dark')
let g:space_vim_dark_background = 234
hi Comment cterm=italic
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
colorscheme space-vim-dark
" }}}
" molokay {{{
"call dein#add('tomasr/molokai')
"let g:molokai_original = 1
"set background=dark
"highlight NonText ctermfg=235 guifg=#262626
"highlight SpecialKey ctermfg=235 guifg=#262626
""highlight PmenuSel ctermfg=231 guifg=#FFFFFF
"highlight CTagsClass ctermfg=81 guifg=#66D9EF
"colorscheme molokai
" }}}
""" }}}

""" Status line {{{
call dein#add('itchyny/lightline.vim')
" Statusline {{{
let g:lightline = {
  \   'colorscheme': 'powerline',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'relativepath', 'altfilename', 'modified' ]
  \     ]
  \   },
  \   'component': {
  \     'lineinfo': ' %3l:%-2v',
  \     'altfilename': '[%{expand(expand("#:t"))}]',
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \     'pathname': 'statusLine#pathName',
  \   }
  \ }

let g:lightline.separator = {
  \   'left': '', 'right': ''
  \}

let g:lightline.subseparator = {
  \   'left': '', 'right': '' 
  \}
" }}}
" Tabline {{{
let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }

let g:lightline.tab = {
  \ 'active': [ 'tabnum', 'filename', 'modified', 'readonly' ],
  \ 'inactive': [ 'tabnum', 'filename', 'modified' ] 
  \ }

let g:lightline.tab_component_function = {
  \ 'filename': 'lightline#tab#filename',
  \ 'modified': 'lightline#tab#modified',
  \ 'readonly': 'lightline#tab#readonly',
  \ 'tabnum': 'lightline#tab#tabnum',
  \ }

set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline
" }}}
""" }}}

""" Session management{{{
call dein#add('mhinz/vim-startify') "{{{
  let g:startify_session_dir = g:cache_dir . g:sps . 'sessions'
  let g:startify_session_delete_buffers = 1
  let g:startify_change_to_dir = 1

  let g:startify_session_before_save = [] "Ex call NERDTreeTabsClose before save

  let g:startify_session_savevars = [
           \ 'g:startify_session_savevars',
           \ 'g:startify_session_savecmds',
           \ 't:tabDescriptor'
           \ ]
  let g:startify_session_sort = 1
  let g:startify_relative_path = 1
  let g:startify_bookmarks = [ {'n': init#FromCnfDir('init.vim')} ]
  let g:startify_padding_left = 2
  let g:startify_update_oldfiles = 1
  let g:startify_fortune_use_unicode = 1

  let g:startify_custom_indices = ['a', 'o', 'e', 'u', 'i', 'd', 'h', 't', 'n',
                  \'s', ';', '.', 'p', 'y', 'f', 'g', 'c', 'r', 'l', 'q',
                  \'x', 'b', 'm', 'w', 'v', 'z']
"}}}
" Custom functions {{{
function! init#LoadSession() "{{{
  let sessionToLoad = init#AskUser("Load Session: ")
  execute 'SLoad ' . sessionToLoad
endfunction"}}}
"}}}
" Custom remap {{{
  let g:lmap.s = { 'name' : '+Sessions'}
  let g:lmap.s.s = ['SSave',  'save-sessions']
  let g:lmap.s.l = ['init#LoadSession()', 'load-sessions']
  let g:lmap.s.c = ['SClose', 'close-sessions']
  let g:lmap.s.d = ['SDelete', 'delete-sessions']
" }}}
augroup sessionsMgmtAutocmd "{{{
  autocmd!
  autocmd TabNewEntered * Startify
augroup END
" }}}
""" }}}

""" Tabs management {{{
call init#SourceSubCnf('tabsMgmt.vim')
"""  }}}

""" Buffer management {{{
call init#SourceSubCnf('bfrMgmt.vim')
""" }}}

""" Documentations {{{ 
" Markdown docs {{{
call init#EnsureExists(g:md_wiki)
call dein#add('plasticboy/vim-markdown')
" }}}

" Latex docs {{{
call init#EnsureExists(g:tex_wiki)
" }}}

" CSV file format {{{
call dein#add('chrisbra/csv.vim')
" }}}
""" }}}

""" Comments management {{{
call dein#add('tpope/vim-commentary')
augroup commentsAutocmd "{{{
  autocmd!
	autocmd FileType vim setlocal commentstring=\"\ %s
	autocmd FileType verilog setlocal commentstring=//\ %s
augroup END " }}}
""" }}}

""" Git tools {{{
call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')
""" }}}

""" fast navigation {{{
call dein#add('justinmk/vim-sneak')
""" }}}

""" Awesome grep {{{
call dein#add('brooth/far.vim')
""" }}}

""" Compilation {{{
" call dein#add('vim-accio')
""" }}}

""" Directory navigation and status {{{
" call dein#add('vim-dirvish')
""" }}}

""" Neoterm management on tabs basis {{{
call dein#add('Shougo/deol.nvim')
""" }}}

""" Dark powered find and completion {{{
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/denite.nvim')
""" }}}


""" Post hook for plugin manager {{{
call dein#end()
if dein#check_install()
  call dein#install()
endif
autocmd VimEnter * call dein#call_hook('post_source')
""" }}}
" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0
