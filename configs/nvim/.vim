let g:qs_enable=1
augroup qs_colors:
  autocmd!
  highlight QuickScopePrimary guifg='#21e00b' gui=underline ctermfg=155 cterm=underline
  highlight QuickScopeSecondary guifg='#21e00b' gui=underline ctermfg=81 cterm=underline
augroup END
