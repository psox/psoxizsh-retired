
" Function to source only if file exists {
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }



exec "set rtp=$VIMHOME," . &rtp 	

call SourceIfExists("~/.config/vim/early.vimrc")

set encoding=utf-8

" (Optional) Multi-entry selection UI.

call plug#begin("$VIMHOME/plugged")
  Plug 'junegunn/vim-easy-align'	
  Plug 'majutsushi/tagbar'	
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'scrooloose/syntastic'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/vim-statline'
  Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
  Plug 'rust-lang/rust.vim'
  Plug 'vim-scripts/taglist.vim'
  Plug 'pearofducks/ansible-vim'
  Plug 'luochen1990/rainbow'
  Plug 'jremmen/vim-ripgrep'
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
  Plug 'junegunn/fzf'
  Plug 'sheerun/vim-polyglot'
  call SourceIfExists("~/.config/vim/plug.vimrc")
  if v:version > 704
  "  Plug 'Valloric/YouCompleteMe'
    Plug 'prabirshrestha/async.vim'
  endif
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

call plug#end()

set number
set relativenumber

execute ':silent !mkdir -p ~/.vimbackup'

set backupdir=~/.vimbackup 
set directory=~/.vimbackup
set hlsearch

" Commenting
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" Syntastic Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Syntastic enable specific checkers
" let g:syntastic_perl_checkers = ["perl"]
" let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_zsh_checker = 1
let g:syntastic_enable_bash_checker = 1

" rust lang
autocmd FileType rust let g:autofmt_autosave = 1
autocmd FileType rust let g:deoplete#enable_at_startup = 1
let g:ycm_rust_src_path = expand('~/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rustc')

" Other
let g:rainbow_active = 1
set shiftwidth=2
set tabstop=8
set softtabstop=2
set expandtab
filetype plugin indent on
autocmd FileType yaml setl indentkeys-=<:>
autocmd FileType yaml setlocal ts=8 sts=2 sw=2 expandtab

colorscheme murphy

cmap w!! w !sudo tee % > /dev/null 

let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" ripgrep settings
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'

nmap <F8> :TagbarToggle<CR>

call SourceIfExists("~/.config/vim/late.vimrc")


set exrc
set secure
set modeline
set modelines=7

" vim: ts=8 sw=2 si
