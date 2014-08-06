"========================================
" Initialize
"========================================
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))


" Use English interface.
if s:is_windows
  " For Windows.
  language message en
else
  " For Linux.
  language message C
endif

if s:is_windows
  " Exchange path separator.
  set shellslash
endif

" In Windows/Linux, take in a difference of ".vim" and "$VIM/vimfiles".
let $DOTVIM = expand('~/.vim')

" Because a value is not set in $MYGVIMRC with the console, set it.
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:set_default(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    silent! unlet {a:var}
    let {a:var} = a:val
  endif
endfunction

" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END

"========================================
"  vundle
"========================================

if has('vim_starting')
  " Set runtimepath.
  if s:is_windows
    let &runtimepath = join([
          \ expand('~/.vim'),
          \ expand('$VIM/runtime'),
          \ expand('~/.vim/after')], ',')
  endif

  if finddir('neobundle.vim', '.;') != ''
    execute 'set runtimepath+=' . finddir('neobundle.vim', '.;')
  elseif &runtimepath !~ '/neobundle.vim'
    execute 'set runtimepath+=' . expand('~/.bundle/neobundle.vim')
  endif

  if s:is_windows
    set runtimepath+=~/vimfiles/bundle/neobundle.vim
    call neobundle#begin(expand('~/vimfiles/bundle'))
  else
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle'))
  endif

endif
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak'
      \ }}

NeoBundle 'sorah/unite-ghq', { 'depends' : 'Shougo/unite.vim'}

NeoBundle 'tyru/caw.vim'

NeoBundle 'nanotech/jellybeans.vim'

call neobundle#end()

" Required:
filetype plugin indent on


" Installation check.
if !has('gui_running') && s:is_windows
  NeoBundleCheck
endif

"========================================
" startup
"========================================
"変更があった際の自動読み込みをWinEnterのタイミングで行う
augroup MyAutoCmd
  autocmd WinEnter * checktime
augroup END

" Enable Singlton
if has('clientserver')
  call singleton#enable()
endif

"========================================
" settings
"========================================
set nocompatible

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

"statusline設定
set laststatus=2
"set statusline=%y%<%F\ %m%r%h%w%=%#warningmsg#%*%{fugitive#statusline()}%{'['.(&fenc!=''?&fenc:&enc).'/'.&ff.']'}[%l/%L,%c]%V%6P
set statusline=%y%<%F\ %m%r%h%w%=%#warningmsg#%*%{'['.(&fenc!=''?&fenc:&enc).'/'.&ff.']'}[%l/%L,%c]%V%6P

"バックスペースで何でも削除
set backspace=indent,eol,start

" 保存時に行末の空白を削除
augroup MyAutoCmd
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

"編集中の内容を保ったまま別のバッファに切り替えられるようにする
set hid

"補完をつかいやすく
set wildmode=list:longest,full

"cursorline
"遅いので
"set cursorline
"set cursorcolumn
" augroup MyAutoCmd
"   autocmd WinEnter * setlocal cursorline
"   autocmd WinLeave * setlocal nocursorline
"   autocmd WinEnter * setlocal cursorcolumn
"   autocmd WinLeave * setlocal nocursorcolumn
" augroup END

" paste toggle
set pastetoggle=<F12>

" nowrapで横方向に一行ずつ画面を切り替える
set sidescroll=1

" スペルチェックをしない
set nospell

" vimgrepを使用した際Quickfixに表示する
au QuickfixCmdPost vimgrep cw

" 外部で変更があった際自動で読み込みます
set autoread

" インクリメント・デクリメントの設定
" 8進数、アルファベットOFF 16進数ON
set nrformats="hex"

" 文字幅のラインを表示します
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=+1
  " プログラミング言語のfiletypeに合わせてください
  augroup MyAutoCmd
    autocmd FileType vim,ruby,python,haskell,scheme setlocal textwidth=80
    autocmd FileType php setlocal textwidth=120
    autocmd FileType markdown setlocal textwidth=120
    autocmd FileType mail setlocal textwidth=50
  augroup END
endif

" :h tagbsearch
set notagbsearch

" ウィンドウサイズの自動調整を無効化
set noequalalways
"set equalalways

" ヤンク、カット時に*レジスタにも入るようにする
if has('unnamed')
  set clipboard+=unnamed
end
if has('unnamedplus')
  set clipboard+=unnamedplus
end

" ハイライトを制限する
set synmaxcol=300

"========================================
" backup
"========================================
set backup
set noswapfile
if has('win32') || has('win64')
  set backupdir=$HOME/vimbak
else
  set backupdir=$HOME/.vimbak
end
let &directory = &backupdir

"========================================
" undo
"========================================
if has('persistent_undo')
  set undodir=~/.vim/undo/
  set undofile
endif

"========================================
" search
"========================================
" Ignore case in search patterns
set ignorecase

" No ignorecase when patterns has upper case
set smartcase

" Enable incremental search
set incsearch

" Searches wrap around the end of file
set wrapscan

" No highlight matches with last search pattern
set nohlsearch

"========================================
" view
"========================================
"行番号を表示
set number

"ルーラーを表示
set ruler

"タブや改行を表示
set list
"set listchars=eol:^,tab:>=
set listchars=tab:>=

"入力中のコマンドをステータスに表示
set showcmd

" Briefly jump to maching bracket if insert one
set showmatch
" Braket highlight when cursor moved
set cpoptions-=m
set matchtime=3
" Highlight <>
set matchpairs+=<:>

" Auto wrap
set wrap

" Always show tabs
set showtabline=2

" Ignore case on insert completion.
set infercase

"========================================
" indent
"========================================
"autoindent
set autoindent
set smartindent

" Recoganize modelines at start or end file
set modeline
set modelines=2

" Use `shiftwidth` when inserting <Tab>
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Round indent to multiple of shiftwidth
" set shiftround

" Use spaces when <Tab> inserting
set expandtab

"========================================
" keymapping
"========================================
"keymapping
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-g> <Esc>

" brackets
" Altkeyはgvim依存
" TODO:端末でも使用可能にする
inoremap <A-{> {}<Left>
inoremap <A-}> {<CR>}<Left><CR><UP><TAB>
inoremap <A-[> []<Left>
inoremap <A-(> ()<Left>
inoremap <A-)> (<CR>)<Left><CR><UP><TAB>
inoremap <A-"> ""<Left>
inoremap <A-'> ''<Left>
inoremap <A-<> <><Left>
inoremap <A-l> <Right>

" ctags new tab and vsp
nnoremap <C-S-]> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <A-\> :sp <CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <Space>. :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <Space>, :<C-u>tabe $MYVIMRC<CR>
nnoremap <Space>/ :<C-u>tabe $MYGVIMRC<CR>
nnoremap <C-h> :<C-u>h<Space>

" コロン、セミコロン入れ替え
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" gf gFの入れ替え
nnoremap gf gF
nnoremap gF gf

" コマンドモード
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>
cnoremap <C-g> <Esc>

" ノーマルモードで改行のみを挿入する(インデント等は含まない)
nnoremap <A-o> :<C-u>call append(expand('.'), '')<Cr>j

" Renameコマンド
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))

" 最後に編集したところを検索
nnoremap gh `[v`]

" select all
nnoremap <space>ga <ESC>ggVG
vnoremap <space>ga <ESC>ggVG

" perlっぽい正規表現のエスケープ
" :help /magic
nnoremap / /\v

"========================================
" Encoding
"========================================
"エンコード設定
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp,euc-jp,cp932
set encoding=utf-8
set fileformats=unix,dos,mac
set nobomb

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

"========================================
" vimproc
"========================================
if has('mac')
  let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/vimproc_mac.so"
elseif has('unix')
  let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/vimproc_linux64.so"
elseif has('win32') || has('win64')
  let g:vimproc_dll_path = $HOME."/vimfiles/bundle/vimproc/autoload/vimproc_win64.dll"
endif

