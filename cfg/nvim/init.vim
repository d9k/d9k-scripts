lua require('config')

set wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif

set cursorlineopt=line,number
au VimEnter * execute 'windo set cursorlineopt=number'
au VimEnter * setlocal cursorlineopt=line,number
au BufEnter * setlocal cursorlineopt=line,number
au BufLeave * setlocal cursorlineopt=number

au VimEnter * if &diff | set foldlevel=1 | endif 

autocmd TextYankPost * silent! let &statusline = 'Yanked text: ' . getreg('+') 
"autocmd CursorMoved * silent! set statusline=%!v:lua.require('nvchad.stl.default')()
fun! s:reset_statusline(timer_id)
    "let &background = (strftime('%H') < 12 ? 'light' : 'dark')
    set statusline=%!v:lua.require('nvchad.stl.default')()
endfun
call timer_start(1000 * 7, function('s:reset_statusline'), {'repeat': -1})

" Copy current file relative path to clipboard
" https://stackoverflow.com/a/17096082/1760643
"nmap <A-c> :let @+ = expand("%:p")<CR>
nmap <A-c> :let @+ = expand("%")<CR>

" Don't overwrite clipboard for "c ..." and "x" commands
noremap c "_c
noremap ci "_ci
noremap x "_x

"unmap <m-l>
"unmap <m-h>
nmap <silent> <m-l> :wincmd l<CR>
nmap <silent> <m-h> :wincmd h<CR>

" Yank line
nnoremap yl "+^y$

" [g]o last [c]ursor position
noremap <leader>gc g`"zz

" [s]peed [s]ave
noremap <leader>ss :w<CR>

"Next/previous heading
map <M-j> /^#<CR>
map <M-k> ?^#<CR>

map <leader>sm :set syntax=markdown<CR>
map <leader>sj :set syntax=json<CR>

" (G[x] becomes accord beginning to [G]o somewhere) which is singular in file
noremap GG G

" GD - [Go] to export [D]efault
map GD /export default<CR>

" Gc - [G]o Vue [c]ss style
map Gt /^<template<CR>

" Gc - [G]o Vue [c]ss style
map Gc /^<style<CR>

" Gc - [G]o Vue [c]ss style
map Gc /^<style<CR>
