" hide menu and toolbar
set guioptions-=m 
set guioptions-=T 

colorscheme railscasts

if has("unix")
    set guifont=Monospace\ 10
elseif has("win32")
    set guifont=Consolas:h10:cANSI
endif
