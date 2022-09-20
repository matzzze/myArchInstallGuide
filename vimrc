set nocompatible

" enable NerdTre "
call pathogen#infect()
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" show hidden files in NerdTree "
let NERDTreeShowHidden=1

" enable mouse support "
set mouse=a

" enable syntax "
syntax on

" enable line numbers "
set number

" enable highlight search pattern "
set hlsearch

" highlight current line "
set cursorline
:highlight Cursorline cterm=bold ctermbg=darkgrey

" enable smartcase search sensivity " 
set ignorecase
set smartcase

" Indentation using spaces "
" tabstop:	width of tab character
" softtabstop:	finetunes the amount of whitespaces to be added
" shiftwidt:	determines the amount of whitespace to add in normal mode
" expandtab:	when on use space instead of tab
" textwidt:	text wrap width
" autoindent:	autoindent in new line
set tabstop 	=4
set softtabstop	=4
set shiftwidth	=4
set expandtab
set autoindent

" show the matching part of pairs [] {} and () "
set showmatch

" remove trailing whitespace from Pyhon files "
autocmd BufWritePre *.py :%s/\s\+$//e

" Remap ctrl+w +h/j/k/l to ctrl +h/j/k/l/ "
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l


" other "
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch

" open terminal below "
cabbrev bt bo term

" split a new file to the right"
set splitright

"change vim statuswindow"
highlight StatuslineFilename ctermfg=Black ctermbg=grey
highlight StatuslineModified ctermfg=Black ctermbg=darkgrey
highlight StatuslineNumbers ctermfg=Black ctermbg=darkgrey

set statusline=%#StatuslineFilename#   " Set color for file path
set statusline+=%F                     " Full file path, at most 40 characters
set statusline+=\                      " A space
set statusline+=%#StatuslineModified#  " Set color for modified flag
set statusline+=%m                     " Modified flag
set statusline+=%#StatuslineFilename#  " Set color for the rest of the bar
set statusline+=%=                     " Split the left and right sides
set statusline+=%#StatuslineNumbers#   " Set color for line numbers
set statusline+=%l                    " Line number
set statusline+=\ \/\                  " A separator
set statusline+=%L                     " Total number of lines
set statusline+=\ \|\                  " A separator
set statusline+=%-3c                    " Column number
