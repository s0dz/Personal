set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'nendre/command-t'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'Valloric/YouCompleteMe'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"================================================================================="

" Options {{{

  set autoindent
  set expandtab
  set sw=2
  set sta
  set ts=2
  set et

  " Show branch name in buffer status line
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

  set bs=2		" allow backspacing over everything in insert mode
  set ai			" always set autoindenting on

  set history=1000		" keep 500 lines of command line history
  set ruler		" show the cursor position all the time
  set incsearch		" do incremental searching
  set ignorecase "Case insensitive search
  set hidden "Remember undo after quitting

  " ctags options
  set tags=./.tags,.tags,./tags,tags

  if ( &ft == "java" )
    set makeprg=vimAnt.sh

    set efm=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,
                \%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
    " Java syntax highlighting. Probably not necessary.
    let java_highlight_all=1
    let java_highlight_functions="style"
    let java_allow_cpp_keywords=1
    " Builtin completion. Goal is to get Java autocompleting
    set complete=.,w,b,u,t,i
  endif

  " You complete me
  let g:ycm_global_ycm_extra_conf = './.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'

  " Open new splits on the right
  set splitright
  set splitbelow 

  " Ignore certain filetypes for command-t searches
  " *** This almost certainly affects many different areas. I think I should use
  " it for ignoring ALL binary data types that I might encounter. ***
  let imgTypes="*.jpg,*.JPG,*.gif,*.png,*.PNG"
  let movTypes="*.mp4,*.MP4,*.AVI,*.mpg,*.MPG,*.PNG"
  let docTypes="*.pdf,*.docx,*.doc,*.aux,*.dvi"
  let javaTypes="*.class,*.cache"
  let cTypes="*.o,*.obj,*.d"
  " This last var should eventually be discarded as everything will be
  " correctly placed into categories
  let otherTypes="*/build/*,*.out,*swp"
  let encrypted="*ECRYPTFS_FNEK_ENCRYPTED"

  execute "set wildignore=".imgTypes
  execute "set wildignore+=".docTypes
  execute "set wildignore+=".javaTypes
  execute "set wildignore+=".cTypes
  execute "set wildignore+=".otherTypes
  execute "set wildignore+=".encrypted


  let g:CommandTAlwaysShowDotFiles = 1
  let g:CommandTScanDotDirectories = 1
  let g:syntastic_mode_map = { 'mode': 'active' }

  " Switch syntax highlighting on, when the terminal has colors
  " Also switch on highlighting the last used search pattern.
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif

  set wildmenu

  " Spell check for commit messages.
  autocmd Filetype gitcommit setlocal spell 

" }}}
" Macros {{{

  " Convert single line old Play SQL statements into inerpolated version
  :let @i='^f(cl""f{i$f"lcl""ldt.'

  " Make quick backup of current file
  :let @b=':! cp % %_backup'
  " Delete backup file
  :let @d=':! rm %_backup'
" }}}
" Themes {{{
  " colors zellner
  " colors torte
  " colors morning
  " colors chocolateliquor
  colors asu1dark
" }}}
" Folds {{{
  set foldmethod=manual
  set foldlevelstart=15

  " Indention based Folding + manual
  "augroup vimrc
  "  au BufReadPre * setlocal foldmethod=indent
  "  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
  "augroup END

  " Manual Folding
  "au BufReadPre * setLocal foldmethod=indent

  " To get ZoomWin working
  set nocp

"}}}
" Functions {{{

  " Highlight cursor after jump
  function! s:Cursor_Moved()
    let cur_pos = winline()
    if g:last_pos == 0
      set cul
      let g:last_pos = cur_pos
      return
    endif
    let diff = g:last_pos - cur_pos
    if diff > 1 || diff < -1
      set cul
    else
      set nocul
    endif
    let g:last_pos = cur_pos
  endfunction
  autocmd CursorMoved,CursorMovedI * call s:Cursor_Moved()
  let g:last_pos = 0

  "Buffer Diffing
  let g:diffed_buffers=[]
  function! DiffText(a, b, diffed_buffers)
    " enew
    execute 'tab split | enew'
    setlocal buftype=nowrite
    call add(a:diffed_buffers, bufnr('%'))
    call setline(1, split(a:a, "\n"))
    diffthis
    vnew
    setlocal buftype=nowrite
    call add(a:diffed_buffers, bufnr('%'))
    call setline(1, split(a:b, "\n"))
    diffthis
  endfunction
  function! WipeOutDiffs(diffed_buffers)
    for buffer in a:diffed_buffers
      execute 'bwipeout! '.buffer
    endfor
    call remove(a:diffed_buffers, 0, -1)
  endfunction

" }}}
" Cscope {{{

  if has('cscope')
    set cscopetag cscopeverbose

    if has('quickfix')
      set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help

    command! -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
  endif

  function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
      let path = strpart(db, 0, match(db, "/cscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db . " " . path
      set cscopeverbose
    endif
  endfunction
  au BufEnter /* call LoadCscope()
  call LoadCscope()

" }}}
" WindowsShit {{{
  " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
  " let &guioptions = substitute(&guioptions, "t", "", "g")

  " IMPORTANT: win32 users will need to have 'shellslash' set so that latex
  " can be called correctly.
  set shellslash
"}}}
" Key Mappings {{{

  " The door to level 3 vimming
  let mapleader = ","

  :nnoremap <silent> <buffer> <leader>i :JavaImport<cr>

  " If the current buffer has never been saved, it will have no name,
  " call the file browser to save it, otherwise just save it.
  command! -nargs=0 -bar Update if &modified 
                             \|    if empty(bufname('%'))
                             \|        browse confirm write
                             \|    else
                             \|        confirm write
                             \|    endif
                             \|endif
  nnoremap <silent> <C-S> :<C-u>Update<CR>

  " Don't use Ex mode, use Q for formatting
  map Q gq

  " Make Capital Y behave like other capitals
  map Y y$

  " Better behavior while scrolling through wrapped lines
  nnoremap j gj
  nnoremap k gk

  " Using H & L to move to beginning and end of line respectively
  map H ^
  map L $

  cmap w!! w !sudo dd of=%

  " Make p in Visual mode replace the selected text with the "" register.
  vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

  " ctags mappings
  map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR> 

  "Paste over visual selection, without copying selection into default register
  vnoremap p "_dP

  " Super-powered undo!
  nnoremap <leader>u :GundoToggle<CR>

  " Spacebar for folds!
  nnoremap <space> za
  nnoremap <S-space> zO

  """ TagBar """
  nmap <leader>n  :TagbarToggle<CR>

  " Easy comparison of 2 arbitrary text put in the a and b buffers
  :nnoremap <special> <F7> :call DiffText(@a, @b, g:diffed_buffers)
  " Remove buffers opened by DiffText
  :nnoremap <special> <F8> :call WipeOutDiffs(g:diffed_buffers) | let g:diffed_buffers=[]

  :map <F2> :echo 'Current time is ' . strftime('%c')<CR>
  :map! <F3> a<C-R>=strftime('%c')<CR><Esc>

  " C++ (Potentially several languages) building
  nnoremap <leader>ma :Make! all<CR>
  nnoremap <leader>mc :Make clean<CR>
  nnoremap <leader>Co :Copen<CR>

  " Unimpared buffer list
  nnoremap <leader>co :copen<CR>

  nnoremap <leader>co :copen<CR>

  " Fugitive
  nnoremap <leader>gs :Gstatus<CR>
  nnoremap <leader>ge :Gedit<CR>
  nnoremap <leader>gl :Glog<CR>
  nnoremap <leader>gL :Glog --<CR>
  nnoremap <leader>go :Git checkout 
  nnoremap <leader>gos :Git checkout SRP-
  nnoremap <leader>gb :Git branch
  nnoremap <leader>gd :Gdiff<CR>
  nnoremap <leader>gvd :Gvdiff<CR>
  nnoremap <leader>gbl :Gblame<CR>

  " nnoremap <leader>dp :diffput
  " nnoremap <leader>dP :diffput | diffup

  " Colon is used MUCH more than semicolon. This is a tiny change, but 
  " oh-so-impactful over the next few decades.
  nnoremap ; :
  nnoremap : ; 

  " Make session
  " nnoremap <leader>ms :! echo "boobs"; echo $(GitOriginUrl.sh); mkdir ~/sessions/$(GitOriginUrl.sh)/; cp ~/sessions/$(GitOriginUrl.sh)/$(GitBranchName.sh).vim ~/.current.vim <CR> :so ~/.current.vim<CR> 
  " Expand this to save sessions from different repos inside different folders
  nnoremap <leader>ms :mksession! ~/.current.vim <CR> :! cp ~/.current.vim ~/sessions/$(GitBranchName.sh).vim <CR>
  nnoremap <leader>ls :! cp ~/sessions/$(GitBranchName.sh).vim ~/.current.vim <CR>:source ~/.current.vim <CR>


  " Cscope bindings
  nnoremap <leader>ff :cs find f 

  " gist-vim bindings
  nnoremap <leader>jn :Gist<CR>
  nnoremap <leader>jl :Gist -l<CR>
  nnoremap <leader>jm :Gist -e -s"
  nnoremap <leader>jd :Gist -d<CR> :bd<CR> :Gist -l<CR>

  " Syntastic 
  cnoreabbrev syntog SyntasticToggleMode

  " Quick window switching
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l


" }}}
" Unsorted {{{

  " Only do this part when compiled with support for autocommands.
  if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " For all text files set 'textwidth' to 78 characters.
    au FileType text setlocal tw=78

    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  endif " has("autocmd")

  au FileType * setl fo-=cro

" }}}
" Meta {{{

  " Update vimrc on write
  au! BufWritePost .vimrc source % 

  " This is useful for sectioning off vimrc. It only applies this folding method when editing vimrc itself
  set modelines=1
  " vim:foldmethod=marker:foldlevel=0


  " Search for selected text, forwards or backwards.
  vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
  vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>

  function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
      let dir=fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction
  augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
  augroup END

" }}}

function! NewHelpKey()
  nnoremap K <C-]>
  let g:tagbar_ctags_bin = "sctags"
endfunction

if has("autocmd")
  autocmd FileType scala call SCTags()
  autocmd FileType scala call NewHelpKey()
endif

let g:easytags_async = 1
