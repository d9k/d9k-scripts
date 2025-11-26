lua require('config')

" Copy current file relative path to clipboard
" https://stackoverflow.com/a/17096082/1760643
"nmap <A-c> :let @+ = expand("%:p")<CR>
nmap <A-c> :let @+ = expand("%")<CR>

" Don't overwrite clipboard for "c ..." and "x" commands
noremap c "_c
noremap ci "_ci
noremap x "_x

" Yank line
nnoremap yl "+^y$

" [g]o last [c]ursor position
noremap <leader>gc g`"

