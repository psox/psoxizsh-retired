
exec "set rtp=$VIMHOME," . &rtp 	

set encoding=utf-8

call plug#begin('~/.psoxizsh/vim/plugged')
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

colorscheme murphy

" vim: ts=8 sw=2 si
