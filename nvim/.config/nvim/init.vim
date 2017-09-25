" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'sebastianmarkow/deoplete-rust'
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/gtk-vim-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
"Plug 'itchyny/lightline.vim'
Plug 'neomake/neomake'
"Plug 'dag/vim-fish'
"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'vim-scripts/gnuplot-syntax-highlighting'
"Plug 'rust-lang/rust.vim'
"Plug 'neovimhaskell/haskell-vim'
Plug 'arakashic/chromatica.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'timonv/vim-cargo'
Plug 'jceb/vim-orgmode'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'

" Initialize plugin system
call plug#end()

set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set number 		        " Show line numbers
set cursorline		    " Show cursor line
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.

set noerrorbells        " No beeps.
set modeline            " Enable modeline.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)
set autochdir
set cino=(0
set cinoptions+=t0
set cindent
set ignorecase
set smartcase
set undofile
set mouse=a

let g:airline_theme='solarized'
let g:airline_powerline_fonts = 0

"let g:lightline = {
"            \ 'colorscheme': 'solarized',
"            \}

let g:ctrlp_types = ['mru', 'fil']

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/christian/src/rust/src'

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeChDirMode = 2
let g:NERDTreeIgnore=['\.vim$', '\~$', '\.o$']

" Colorscheme
set background=dark
colorscheme solarized

" Run Neomake on every file save
autocmd! BufWritePost * Neomake!

let g:neomake_py_flake8_maker = {
    \ 'args': ['--ignore=E221,E241,E272,E251,W702,E203,E201,E202',  '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
let g:neomake_python_enabled_makers = ['flake8']

function! SwitchBuffer()
  b#
endfunction

" disable ex mode
nnoremap Q <Nop>

nnoremap <Tab> :call SwitchBuffer()<CR>
nnoremap <F7> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>
