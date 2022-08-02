
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

set number
set relativenumber
try
  set signcolumn=auto
catch
  set signcolumn=yes:1
endtry

" Use existing buffers
set switchbuf="useopen,usetab"

if exists('+termguicolors')
  set termguicolors
endif

exec "set rtp=$VIMHOME," . &rtp

" Better if check for loading plugins
" This one won't cause vim-plug to autodelete 'unloaded' plugins
function! LoadIf(check, ...)
  let opts = get(a:000, 0, {})
  " Use opts, or default to not loading plugin
  return a:check ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Check if we can use async Syntastic
let useNeomake = has('nvim') || v:version > 800

call SourceIfExists(g:rc_files['pre'])
call plug#begin("$VIMHOME/plugged")
  Plug 'junegunn/vim-easy-align'
  Plug 'tmsvg/pear-tree'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/vim-statline'
  Plug 'qpkorr/vim-bufkill'
  Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'pearofducks/ansible-vim', { 'for':  ['yaml', 'yml'] }
  Plug 'luochen1990/rainbow'
  Plug 'kevinoid/vim-jsonc'
  Plug 'junegunn/fzf', { 'on': ['FZF', '<Plug>fzf#run', '<Plug>fzf#wrap'] }
  Plug 'junegunn/fzf.vim'
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
  Plug 'romainl/vim-qf', LoadIf(useNeomake)

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
  " Don't move cursor into qf/loc on open
  let g:neomake_open_list = 2
  " Allow multiple makers to resolve
  let g:neomake_serialize = 1
  let g:neomake_serialize_abort_on_error = 1
  " Run on write (instant) + read (800ms) buffers
  call neomake#configure#automake('rw', 800)

  " Disable inherited syntastic if it exists
  if has_key(plugs, 'syntastic')
    let g:syntastic_mode_map = {
      \ "mode": "passive",
      \ "active_filetypes": [],
      \ "passive_filetypes": [] }
  endif
endif

" If we can't use Neomake, fall back to Syntastic
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

" vim-qf
if has_key(plugs, 'vim-qf')
  " Don't force qf/loc windows to bottom
  let g:qf_window_bottom = 0
  let g:qf_loclist_window_bottom = 0

  " Let Neomake control window size
  if useNeomake
    let g:qf_auto_resize = 0
  endif
endif

" ripgrep settings
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'

" Balance pairs when on open, close and delete
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

" Other
let g:rainbow_active = 1
augroup PsoxFileAutos
  autocmd!
  autocmd FileType yaml setlocal indentkeys-=<:> ts=8 sts=2 sw=2 expandtab
  autocmd FileType go   setlocal ts=4 sts=4 sw=4 noexpandtab
        \| autocmd BufWritePre <buffer> silent :call CocAction('format')
  " Tidy nerdtree windiw
  autocmd FileType nerdtree setlocal nocursorcolumn nonumber norelativenumber signcolumn=no
  " Autoinstall absent plugins
  autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync
        \| q
        \| execute "colorscheme " . g:my_color_scheme
        \| endif

  if has_key(plugs, 'coc.nvim')
    " Highlight the symbol and its references when hovering
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  endif

  " Force non file buffers to not pollute the buffer list
  autocmd FileType quickfix,netrw setlocal nobuflisted

  " Actually kill netrw when trying to quit it
  autocmd FileType netrw nnoremap <buffer><silent> <Esc> :call <SID>CloseNetrw()<CR>
augroup END

function! s:CloseNetrw() abort
  for bufn in range(1, bufnr('$'))
    if bufexists(bufn) && getbufvar(bufn, '&filetype') ==# 'netrw'
      silent! execute 'bwipeout ' . bufn
      if getline(2) =~# '^" Netrw '
        silent! bwipeout
      endif
      return
    endif
  endfor
endfunction

" Set bindings for coc.nvim
if has_key(plugs, 'coc.nvim') && executable("node")
    if !exists("g:coc_global_extensions")
        let g:coc_global_extensions=[]
    endif
    let g:coc_global_extensions+=[ 'coc-yank' ]
    let g:coc_global_extensions+=[ 'coc-spell-checker' ]
    let g:coc_global_extensions+=[ 'coc-vimlsp' ]
    let g:coc_global_extensions+=[ 'coc-rust-analyzer' ]
    let g:coc_global_extensions+=[ 'coc-json' ]
    let g:coc_global_extensions+=[ 'coc-markdownlint' ]
    let g:coc_global_extensions+=[ 'coc-yaml' ]

    " Do action on current word
    nmap <silent> <leader>. <Plug>(coc-codeaction-selected)w

    " Do action on a selection
    nmap <silent> <leader>/ <Plug>(coc-codeaction-selected)
    xmap <silent> <leader>/ <Plug>(coc-codeaction-selected)

    " rename symbol
    nmap <silent> <leader>rn <Plug>(coc-rename)
    " goto definition / references
    nmap <silent> <leader>gd <Plug>(coc-definition)
    nmap <silent> <leader>gr <Plug>(coc-references)

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

    " Remap PageUp and PageDown for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      " Normal
      nnoremap <silent><nowait><expr> <PageDown> coc#float#has_scroll() ? coc#float#scroll(1) : "\<PageDown>"
      nnoremap <silent><nowait><expr> <PageUp> coc#float#has_scroll() ? coc#float#scroll(0) : "\<PageUp>"
    endif

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Open yank list
    nnoremap <silent> <C-Y> :<C-u>CocList -A --normal yank<CR>
endif

" FZF overides
if has_key(plugs, 'fzf.vim')
  if executable('rg')
    " Only search file contents, not file name
    " We can use the stock :Files for that
    command! -bang -nargs=* Rg call
          \ fzf#vim#grep(
            \ "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
            \ 1,
            \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
            \ <bang>0
          \ )

    " Override the default grep implementation in vim
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow

    " If the user hasn't set a default FZF command, and has ripgrep installed,
    " use it over find, otherwise defer to the user's preferred command
    if empty($FZF_DEFAULT_COMMAND)
      command! -bang -nargs=? -complete=dir Files call
            \ fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'rg --files --hidden --glob "!**/.git/**" ' }), <bang>0)
    endif

    nnoremap <A-g> :Rg
    nnoremap <leader><A-g> :Rg!
    nnoremap <silent> <A-S-g> :Rg<CR>
    nnoremap <silent> <leader><A-S-g> :Rg!<CR>
  endif

  nnoremap <A-f> :Files
  nnoremap <leader><A-f> :Files!
  nnoremap <silent> <A-S-f> :Files<CR>
  nnoremap <silent> <leader><A-S-f> :Files!<CR>

<<<<<<< HEAD
  nnoremap <A-b> :Buffers
=======
  nnoremap <A-b> :Buffers 
>>>>>>> origin/develop
  nnoremap <leader><A-b> :Buffers!
  nnoremap <silent> <A-S-b> :Buffers<CR>
  nnoremap <silent> <leader><A-S-b> :Buffers!<CR>
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
    exec "set nonumber norelativenumber signcolumn=no nolist"
  else
    exec "set number relativenumber list"
    try | set signcolumn=auto | catch | set signcolumn=yes:1 | endtry
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
