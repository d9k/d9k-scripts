lua require('config')

" Copy current file full path to clipboard
nmap <A-c> :let @+ = expand("%:p")<CR>

" Don't overwrite clipboard for "c ..." and "x" commands
noremap c "_c
noremap ci "_ci
noremap x "_x

" Yank line
nnoremap yl "+^y$

