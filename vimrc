
" Function to source only if file exists {
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }

let g:rc_files = {
  \ 'early': '~/.config/vim/early.vimrc',
  \ 'pre':   '~/.config/vim/pre-plug.vimrc',
  \ 'plug':  '~/.config/vim/plug.vimrc',
  \ 'post':  '~/.config/vim/post-plug.vimrc',
  \ 'late':  '~/.config/vim/late.vimrc',
  \ 'my':    $MYVIMRC
  \ }

" Edit source files
function! EditVimRcFiles()
  for l:rc_key in keys(g:rc_files)
    let l:ex_file = expand(g:rc_files[l:rc_key])
    if filereadable(l:ex_file)
      exe 'edit' l:ex_file
    endif
  endfor
endfunction

call SourceIfExists(g:rc_files['early'])

" set preferred color scheme if not set
if !exists("g:my_color_scheme")
  let g:my_color_scheme='one'
endif

" Hide buffers don't close them
set hidden

" Sane pane opening
set splitbelow
set splitright

" File indent opts
set shiftwidth=2
set tabstop=8
set softtabstop=2
set expandtab
set encoding=utf-8
try
  " Vim 8.2 only
  exec "set listchars=trail:\u02FD,extends:\u22B3,precedes:\u22B2,nbsp:\u02EC,conceal:\u2219,tab:\u2559\u254C\u2556"
catch
  exec "set listchars=trail:\u02FD,extends:\u22B3,precedes:\u22B2,nbsp:\u02EC,conceal:\u2219,tab:\u2559\u254C"
endtry
set list
set ignorecase
set infercase
filetype plugin indent on

" Set completion messages off
set shortmess+=c

" Preview window + menu for autocompletions
set completeopt+=preview
set completeopt+=menuone
set completeopt+=longest

" Lower update time (Default 4000)
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
try
  " Vim 8.2 only
  set signcolumn=number
catch
  set signcolumn=yes:1
endtry
set number
set relativenumber

if exists('+termguicolors')
  set termguicolors
endif

exec "set rtp=$VIMHOME," . &rtp

function! LoadIf(check, ...)
  let opts = get(a:000, 0, {})
  " Use opts, or default to not loading plugin
  return a:check ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

let useNeomake = has('nvim') || v:version > 800

call SourceIfExists(g:rc_files['pre'])
call plug#begin("$VIMHOME/plugged")
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/vim-statline'
  Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'pearofducks/ansible-vim', { 'for':  ['yaml', 'yml'] }
  Plug 'luochen1990/rainbow'
  Plug 'kevinoid/vim-jsonc'
  Plug 'jremmen/vim-ripgrep', { 'on': ['Rg', 'RgRoot'] }
  Plug 'junegunn/fzf', { 'on': ['FZF', '<Plug>fzf#run', '<Plug>fzf#wrap'] }
  Plug 'junegunn/fzf.vim',
  Plug 'sheerun/vim-polyglot'
  Plug 'adelarsq/vim-matchit'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
  Plug 'rakr/vim-one'
  Plug 'mox-mox/vim-localsearch'
  Plug 'romainl/vim-cool'
  Plug 'christoomey/vim-tmux-navigator', { 'on': ['TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious'] }

  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'scrooloose/syntastic', LoadIf(!useNeomake)
  Plug 'neomake/neomake', LoadIf(useNeomake)

  Plug 'roxma/nvim-yarp', LoadIf(has('nvim'))
  Plug 'roxma/vim-hug-neovim-rpc', LoadIf(has('nvim'))
  call SourceIfExists(g:rc_files['plug'])
call plug#end()
call SourceIfExists(g:rc_files['post'])

execute ':silent !mkdir -p ~/.vimbackup'

set backupdir=~/.vimbackup
set directory=~/.vimbackup
set hlsearch

" Airline
" Airline replaces showmode
set noshowmode
let g:airline#extensions#branch#format = 2
let g:airline#extensions#branch#displayed_head_limit = 16
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_theme='one'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Commenting
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

augroup PsoxNERDTree
  autocmd!
  " Autoquit if nerdtree is last open window
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " Open nerdtree if opening a directory
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
augroup END

if useNeomake
  let g:neomake_open_list = 2
  let g:neomake_serialize = 1
  let g:neomake_serialize_abort_on_error = 1
  " Run on write (instant) + read (800ms) buffers
  call neomake#configure#automake('rw', 800)

  if has_key(plugs, 'syntastic')
    " Disable inherited syntastic
    let g:syntastic_mode_map = {
      \ "mode": "passive",
      \ "active_filetypes": [],
      \ "passive_filetypes": [] }
  endif
endif

if !useNeomake
  " Syntastic Settings
  " Note that airline automatically configures these
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_enable_signs = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  " Syntastic enable specific checkers
  let g:syntastic_enable_zsh_checker = 1
  let g:syntastic_enable_bash_checker = 1
endif

" ripgrep settings
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'

" Other
let g:rainbow_active = 1
augroup PsoxFileAutos
  autocmd!
  autocmd FileType rust let g:autofmt_autosave = 1
  autocmd FileType yaml setlocal indentkeys-=<:> ts=8 sts=2 sw=2 expandtab
  " Tidy nerdtree windiw
  autocmd FileType nerdtree setlocal nocursorcolumn nonumber norelativenumber signcolumn=no
  autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync
        \| q
        \| execute "colorscheme " . g:my_color_scheme
        \| endif
augroup END

" Set bindings for coc.nvim
if has_key(plugs, 'coc.nvim')
    if !exists("g:coc_global_extensions")
        let g:coc_global_extensions=[]
    endif
    let g:coc_global_extensions+=[ 'coc-yank' ]
    let g:coc_global_extensions+=[ 'coc-spell-checker' ]
    let g:coc_global_extensions+=[ 'coc-actions' ]
    let g:coc_global_extensions+=[ 'coc-vimlsp' ]
    let g:coc_global_extensions+=[ 'coc-rust-analyzer' ]
    let g:coc_global_extensions+=[ 'coc-json' ]
    let g:coc_global_extensions+=[ 'coc-markdownlint' ]
    let g:coc_global_extensions+=[ 'coc-yaml' ]
    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <A-space> to trigger completion.
    inoremap <silent><expr> <A-space> coc#refresh()

    " Use <c-space> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    " <c-space> could be remapped by other vim plugin, try `:verbose imap <CR>`.
    if exists('*complete_info')
      inoremap <expr> <C-space> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <C-space> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction 

    " Remap for do codeAction of selected region
    function! s:cocActionsOpenFromSelected(type) abort
      execute 'CocCommand actions.open ' . a:type
    endfunction
    xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
    nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
    nmap <silent> <leader>. :CocCommand actions.open<CR>

    nnoremap <silent> <C-Y> :<C-u>CocList -A --normal yank<CR>
endif

" Vim Tmux unified movement
if has_key(plugs, 'vim-tmux-navigator')
  let g:tmux_navigator_no_mappings = 1
  let g:tmux_navigator_disable_when_zoomed = 1

  nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
endif

" NERDTree Toggle
nnoremap <F2> :NERDTreeToggle<CR>

" Workaround for writing readonly files
cnoremap w!! w !sudo tee % > /dev/null

" Vim config(s) editing
nnoremap <leader>ve :call EditVimRcFiles()<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>
nnoremap <leader>vl <Plug>localsearch_toggle

" Toggles all gutter items
nnoremap <silent> <leader>N :call ToggleGutter()<CR>

function! ToggleGutter() abort
  if &number
    exec "set nonumber norelativenumber signcolumn=no"
  else
    exec "set number relativenumber"
    try | set signcolumn=number | catch | set signcolumn=yes:1 | endtry
  endif
endfunction

" Buffer movement
nnoremap <silent> <TAB> :call BufferJump("bnext")<CR>
nnoremap <silent> <S-TAB> :call BufferJump("bprevious")<CR>
nnoremap <silent> <leader><TAB> :call ListBuffers()<CR>

function BufferJump(command)
  let start_buffer = bufnr('%')
  execute a:command
  while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
    execute a:command
  endwhile
endfunction

function ListBuffers()
  try
    Buffers
  catch
    buffers<CR>b<space>
  endtry
endfunction

" Default colorscheme
set background=dark
let g:one_allow_italics=1
execute "colorscheme " . g:my_color_scheme
highlight Comment term=italic cterm=italic gui=italic

set exrc
set secure
set modeline
set modelines=7

call SourceIfExists(g:rc_files['late'])
" vim: ts=8 sw=2 si
