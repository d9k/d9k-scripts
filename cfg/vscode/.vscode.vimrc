" https://aka.ms/vscodevim
" https://vi.stackexchange.com/a/12616/51529
"
" [.vimrc · VSCodeVim/Vim Wiki](https://github.com/VSCodeVim/Vim/wiki/.vimrc)
" Currently, only remap commands are recognized in .vimrc files. All other commands, such as set or if are silently ignored.
"let @p='i ^[p'

" `:source` not implemented in VS Code 
" so mapped `workbench.action.reloadWindow` to `Ctrl-K Ctrk-W` in VS Code

" ? unmap next tab
unmap gt

noremap GG G
" Search in Vue single find component for sections
"map <leader>Gs /^<script<CR>
"map <leader>Gt /^<template<CR>
"map <leader>Gc /^<style<CR>
map GS /^<script<CR>
map GT /^<template<CR>
map GC /^<style<CR>
map GE /\bextends\b<CR>w
map GI gg/^import\b<CR>

" For temporary testing
map <leader>T iii

unmap <A-n>


