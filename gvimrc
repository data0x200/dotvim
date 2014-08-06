scriptencoding utf-8

augroup highlightIdegraphicSpace
  autocmd!
   autocmd ColorScheme * highlight WhitespaceEOL ctermbg=DarkGray guibg=DarkGray
   autocmd VimEnter,WinEnter * match WhitespaceEOL /\s\+$/
augroup END

colorscheme jellybeans

if has('mac')
  set guifont=Ricty\ Discord:h16
elseif has('unix')
  set guifont=Ricty\ 14
end

set guioptions-=m
set guioptions-=T
set guioptions-=R
set guioptions-=L
