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
  let $MYGVIMRC = expand('~/.vim/gvimrc')
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
NeoBundle 'Shougo/neomru.vim', { 'depends' : 'Shougo/unite.vim'}
NeoBundle 'taka84u9/unite-git', { 'depends' : 'Shougo/unite.vim' }
NeoBundle 'sorah/unite-ghq', { 'depends' : 'Shougo/unite.vim'}

NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'Shougo/neocomplete.vim'

NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \      'VimShell',
      \      'VimShellPop'
      \ ]}}

NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'autoload' : {
      \   'commands' : ['QuickRun']
      \ }}
NeoBundleLazy 'mattn/zencoding-vim', {
      \ 'autoload' : {
      \   'filetypes' : ['html', 'eruby', 'haml', 'slim', 'xml', 'css', 'php']
      \ }}
NeoBundleLazy 'ujihisa/shadow.vim', {
      \ 'autoload' : {
      \   'filetypes' : ['shadow']
      \ }}
NeoBundle 'kana/vim-submode'
NeoBundle 'tpope/vim-surround'
NeoBundleLazy 'tpope/vim-rails', {
      \ 'autoload' : {
      \   'commands' : ['R', 'A']
      \ }}
NeoBundleLazy 'sudo.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'SudoWrite',
      \     'SudoRead'
      \ ]}}
NeoBundle 'kana/vim-smartinput', {
      \ 'autoload' : {
      \   'insert' : '1'
      \ }}
NeoBundleLazy 'kana/vim-smartchr',  {
      \ 'autoload' : {
      \   'insert' : '1'
      \ }}
NeoBundle 'bling/vim-airline'
NeoBundle 'scrooloose/syntastic'
NeoBundleLazy 'rhysd/clever-f.vim', {
      \ 'autoload' : {
      \ 'mappings' : ['f']
      \ }}
NeoBundle 'matchit.zip'
NeoBundle 'osyo-manga/vim-over'
NeoBundleLazy 'koron/codic-vim', {
      \ 'autoload' : {
      \ 'commands': ['Codic']
      \ }}
NeoBundle 'kana/vim-tabpagecd'

" Language
NeoBundleLazy 'vim-ruby/vim-ruby', {
      \ 'autoload' : {
      \   'filetypes' : ['ruby']
      \ }}
NeoBundleLazy 'jnwhiteh/vim-golang', {
      \ 'autoload' : {
      \   'filetypes' : ['go']
      \ }}
NeoBundleLazy 'nsf/gocode', {
      \ 'rtp' : 'vim',
      \ 'autoload' : {
      \   'filetypes' : ['go']
      \ }}
NeoBundleLazy 'slim-template/vim-slim', {
      \ 'autoload' : {
      \ 'filetypes' : ['slim']
      \ }}
NeoBundleLazy 'kchmck/vim-coffee-script', {
      \ 'autoload' : {
      \   'filetypes' : ['coffee']
      \ }}
NeoBundleLazy 'mxw/vim-jsx', {
      \ 'autoload' : {
      \   'filetypes' : ['jsx']
      \ }}


" colorscheme
NeoBundle 'nanotech/jellybeans.vim'

call neobundle#end()

" Required:
filetype plugin indent on
syntax on

" Installation check.
NeoBundleCheck

"========================================
" startup
"========================================
"変更があった際の自動読み込みをWinEnterのタイミングで行う
augroup MyAutoCmd
  autocmd WinEnter * checktime
augroup END

let plugin_cmdex_disable = 1

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

" gj, gkの入れ替え
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

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
" Plugins
"========================================
"----------------------------------------
" Unite
"----------------------------------------
call unite#custom#profile('default', 'context', {
      \ 'start_insert' : 1,
      \ 'winheight' : '30',
      \ 'vertical' : 1,
      \ 'ignorecase' : 1,
      \ })
call unite#custom#profile('neobundle/update', 'context', {
      \ 'auto_quit' : 1
      \ })
nnoremap <Space>gr :<C-u>Unite git_cached<CR>
nnoremap <Space>ua :<C-u>Unite buffer file_mru<CR>

"----------------------------------------
" vimproc
"----------------------------------------
if has('mac')
  let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/vimproc_mac.so"
elseif has('unix')
  let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/vimproc_linux64.so"
elseif has('win32') || has('win64')
  let g:vimproc_dll_path = $HOME."/vimfiles/bundle/vimproc/autoload/vimproc_win64.dll"
endif

"----------------------------------------
" VimFiler
"----------------------------------------
let g:vimfiler_as_default_explorer = 1

nnoremap <Space>fc :<C-u>VimFilerCurrentDir<CR>
nnoremap <Space>ff :<C-u>VimFilerBufferDir<CR>

"----------------------------------------
" neocomplete
"----------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_auto_select=0
let g:neocomplete#enable_auto_close_preview=0

inoremap <expr><C-m> neocomplete#smart_close_popup()."\<C-m>"
inoremap <expr><C-g> neocomplete#smart_close_popup()
inoremap <expr><C-l> neocomplete#start_manual_complete()
inoremap <expr><TAB> neocomplete#close_popup()
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

"----------------------------------------
" VimShell
"----------------------------------------
nnoremap <Space>p :<C-u>VimShellPop<CR>

"----------------------------------------
" zen-coding
"----------------------------------------
 let g:user_zen_settings = {
  \ 'indentation' : '  ',
  \ 'php' : {
  \   'extends' : 'html',
  \   'filters' : 'c',
  \ },
  \ 'xml' : {
  \   'extends' : 'html',
  \ },
  \ 'haml' : {
  \   'extends' : 'html',
  \ },
  \ 'erb' : {
  \   'extends' : 'html',
  \ },
  \}

"----------------------------------------
" open-browser.vim
"----------------------------------------
nmap <Leader>o <Plug>(openbrowser-open)

"----------------------------------------
" quickrun
"----------------------------------------
" %cはcommandに設定した値に置換される
" %oはcmdoptに設定した値に置換される
" %sはソースファイル名に置換される
let g:quickrun_config = {}
let g:quickrun_config['_'] = {
      \ 'shebang' : '1',
      \ 'runner' : 'remote/vimproc:100'
      \ }
let g:quickrun_config['coffee'] = {
      \ 'command' : 'coffee',
      \ 'filetype' : 'javascript',
      \ 'exec'    : ['%c -cbp %s']
      \ }
let g:quickrun_config['ruby.rspec'] = {
      \ 'type': 'ruby',
      \ 'command': 'ruby',
      \ 'outputter': 'buffer',
      \ 'exec': 'bundle exec %c %o %s'
      \}
let g:quickrun_config['ruby.rspec'] = {
      \ 'type': 'ruby.rspec',
      \ 'command': 'rspec',
      \ 'outputter': 'buffer',
      \ 'filetype': 'rspec-result',
      \ 'exec': 'bundle exec %c %o --color %s'
      \}
let g:quickrun_config['html'] = {
      \ 'command' : 'open',
      \ 'runner'  : 'system'
      \ }
let g:quickrun_config['xhtml'] = {
      \ 'command' : 'firefox',
      \ 'runner'  : 'system'
      \ }
let g:quickrun_config['javascript'] = {
      \ 'command' : 'js2coffee',
      \ 'exec'    : ['cat %s|%c']
      \ }
let g:quickrun_config.markdown = {
      \ 'command'   : 'pandoc',
      \ 'exec' : "%c %s",
      \ 'runner'    : 'system'
      \ }
"let g:quickrun_config['markdown'] = {
"      \ 'exec'      : ['firefox | %c'],
"      \ 'outputter' : 'browser',
"      \ 'runner'    : 'system'
"      \ }

nnoremap <Leader>q :<C-u>QuickRun<CR>
nnoremap <Leader>, :<C-u>QuickRun<CR>
nnoremap <Space>r :<C-u>QuickRun<CR>
nnoremap <expr><silent> <Leader>lr "<Esc>:QuickRun -cmdopt \"-l " . line(".") . "\"<CR>"

"----------------------------------------
" vim-submode
"----------------------------------------
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')


"----------------------------------------
" syntastic
"----------------------------------------
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_signs = 1

let g:syntastic_javascript_checkers = ["jshint"]
let g:syntastic_json_checkers = ["jsonlint"]

let g:syntastic_mode_map = {
      \ 'mode' : 'active',
      \ 'active_filetypes' : [],
      \ 'passive_filetypes' : ['haml', 'scss']
      \}

nnoremap <Space>e :<C-u>Errors<CR>

"----------------------------------------
" smartchr
"----------------------------------------

"----------------------------------------
" smartinput
"----------------------------------------
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
      \ 'at'       : '\({\|\<do\>\)\s*\%#',
      \ 'char'     : '<Bar>',
      \ 'input'    : '<Bar><Bar><Left>',
      \ 'filetype' : ['ruby'],
      \  })

call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
      \ 'at'       : '"\%#"',
      \ 'char'     : '#',
      \ 'input'    : '#{}<Left>',
      \ 'filetype' : ['ruby'],
      \ 'syntax'   : ['Constant', 'Special'],
      \ })

call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
      \ 'at'       : '<%\%#',
      \ 'char'     : '<Space>',
      \ 'input'    : '  %><Left><Left><Left>',
      \ 'filetype' : ['eruby'],
      \ })

call smartinput#map_to_trigger('i', '=', '=', '=')
call smartinput#define_rule({
      \ 'at' : '<%\%#',
      \ 'char' : '=',
      \ 'input' : '=  %><Left><Left><Left>',
      \ 'filetype' : ['eruby'],
      \ })

"========================================
" Language
"========================================

"----------------------------------------
" Golang
"----------------------------------------
 set completeopt=menuone,preview
 let g:gofmt_command = 'goimports'

 augroup MyAutoCmd
   autocmd FileType go autocmd BufWritePre <buffer> Fmt
   autocmd FileType go compiler go
 augroup END

"----------------------------------------
" Ruby
"----------------------------------------
augroup MyAutoCmd
  autocmd BufReadPost *_spec.rb set filetype=ruby.rspec
augroup END

"----------------------------------------
" Rails
"----------------------------------------
augroup MyAutoCmd
  autocmd BufEnter * if exists("b:rails_root") | NeoCompleteSetFileType ruby.rails | endif
augroup END
command! V Rview

"----------------------------------------
" Slim
"----------------------------------------
augroup MyAutoCmd
  autocmd BufReadPost *.slim set filetype=slim
augroup END

"----------------------------------------
" Coffee
"----------------------------------------
augroup MyAutoCmd
  autocmd BufReadPost *.coffee set filetype=coffee
augroup END
