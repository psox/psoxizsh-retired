
exec "set rtp=$VIMHOME," . &rtp 	

set encoding=utf-8

call plug#begin("$VIMHOME/plugged")
  Plug 'junegunn/vim-easy-align'	
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
  if v:version > 704
    Plug 'Valloric/YouCompleteMe'
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
let g:ycm_rust_src_path = '~/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rustc'

" Other
filetype plugin indent on
autocmd FileType yaml setl indentkeys-=<:>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

colorscheme murphy

cmap w!! w !sudo tee % > /dev/null 


" vim: ts=8 sw=2 si
