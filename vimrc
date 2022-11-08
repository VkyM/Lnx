" ---------------------------vundle-begin----------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'vimwiki/vimwiki'
Plugin 'preservim/vim-markdown'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" ---------------------------vundle-end----------------------------

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


"----------------vimwiki----------------------------------
" let g:vimwiki_list = [{'path': '~/', 'path_html': '.', 'syntax': 'markdown', 'custom_wiki2html': 'vimwiki_markdown'}]
let g:vimwiki_list = [{
	\ 'path': '~/vimwiki',
	\ 'template_path': '~/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'path_html': '~/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_ext': '.tpl'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown', '.wiki': 'markdown'}


" Set no swap while using it
set noswapfile
" Enable highlight while search
set hlsearch
" in normal mode F2 will save the file
nmap <F2> :w<CR>
" in insert mode F2 will exit insert, save, enters insert again
imap <F2> <ESC>:w<CR>i

" Ctrl+n List the directories and files in the current directory in left side
map <c-n> :NERDTreeToggle<CR>

" Open the terminal in below the vim editor
map <c-t> :botright terminal<CR>

" Syntax mode ON
syntax on

" moloki is better option for colorsheme
colorscheme molokai

set relativenumber

" It does not wrap text when reach termial end of line
set nowrap

" It is flexible for programmer
set smartindent

" highlight matching braces
set showmatch
set mouse=a " Enable mouse in vim editor

set cursorline " Enable cursor line on vim
set paste   " ctrl+shift+v

" Highlight the cursor line
hi CursorLine term=bold cterm=bold ctermbg=black guibg=Grey40  

" Set ruler
set ruler

" To debug c file using F6 key
packadd termdebug
autocmd filetype c nnoremap <F6> :Termdebug %:r<CR><c-w>2j<c-w>L

