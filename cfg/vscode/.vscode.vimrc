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

" Search in Vue single find component for sections
nmap <leader>gs /^<script<CR>
nmap <leader>gt /^<template<CR>
nmap <leader>gc /^<style<CR>
nmap gs /^<script<CR>
nmap gt /^<template<CR>
nmap gc /^<style<CR>

" For temporary testing
map <leader>T iii
